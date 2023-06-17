import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:path_provider/path_provider.dart';

class GithubAuthService {
  const GithubAuthService();

  Future<String?> getToken() async {
    final File authToken = await getCachedTokenFile();

    // Check if token exists and verify duration
    if (authToken.existsSync()) {
      final Map<String, dynamic> cachedTokenData = jsonDecode(authToken.readAsStringSync());
      if (cachedTokenData.isNotEmpty) {
        if (cachedTokenData.containsKey('token') && cachedTokenData.containsKey('createdAt')) {
          final expireAt = DateTime.parse(cachedTokenData['createdAt']!);
          if (DateTime.now().difference(expireAt) < const Duration(hours: 1)) {
            return cachedTokenData['token'];
          }
        }
      }
    }

    final String appJWT = _buildNewJWT(duration: const Duration(minutes: 10));
    final createdAt = DateTime.now();
    final response = await requestNewAuthToken(appJWT);

    final jsonResponse = jsonDecode(response.body);
    final token = jsonResponse['token'];

    if (response.statusCode == 201) {
      if (!await authToken.exists()) {
        authToken.create();
      }

      final tokenJsonContent = {"token": token, "createdAt": createdAt.toIso8601String()};
      authToken.writeAsString(jsonEncode(tokenJsonContent));
    }

    return jsonResponse['token'];
  }

  Future<http.Response> requestNewAuthToken(String appJWT) async {
    String installmentId = const String.fromEnvironment('MM_GITHUB_INSTALLMENT_ID');
    final Uri githubInstallmentUri = Uri.parse(
      'https://api.github.com/app/installations/$installmentId/access_tokens',
    );
    final Map<String, String> githubHeader = {
      'Accept': 'application/vnd.github+json',
      'Authorization': 'Bearer $appJWT',
      'X-GitHub-Api-Version': '2022-11-28'
    };
    return await http.Client().post(githubInstallmentUri, headers: githubHeader);
  }

  String _buildNewJWT({required Duration duration}) {
    final jwt = JWT({'alg': 'RS256'}, issuer: const String.fromEnvironment('MM_GITHUB_APP_ID'));
    String pem = getPemFromEnvironment();

    final token = jwt.sign(
      RSAPrivateKey(pem),
      algorithm: JWTAlgorithm.RS256,
      expiresIn: duration,
    );

    return token;
  }

  Future<File> getCachedTokenFile() async {
    final appDirectory = await getApplicationSupportDirectory();
    return File('${appDirectory.path}${Platform.pathSeparator}github_auth_token.json');
  }

  String getPemFromEnvironment() {
    String pemFrom64 = const String.fromEnvironment('MM_GITHUB_PRIVATE_KEY');
    return utf8.decode(base64.decode(pemFrom64));
  }
}
