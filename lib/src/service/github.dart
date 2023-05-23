import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:modmopet/src/entity/git_source.dart';
import 'package:universal_html/controller.dart';
import 'package:universal_html/html.dart';

class GithubService {
  GithubService._();
  static final instance = GithubService._();

  Future<String?> getLatestCommitHash(GitSource source) async {
    final controller = WindowController();
    final Uri fetchUri = Uri.parse('${source.uri}/commits/${source.branch}');

    try {
      debugPrint('Try spoofing from commit hash from: $fetchUri');
      await controller.openUri(fetchUri);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
    final Element? commitElement =
        controller.window.document.documentElement?.querySelector('li.Box-row div.Details a');

    String? commitUri = commitElement?.attributes.entries.firstWhere((element) => element.key == 'href').value;

    return commitUri?.split('/').last;
  }
}
