import 'dart:async';
import 'package:github/github.dart';
import 'package:modmopet/src/entity/git_source.dart';
import 'package:modmopet/src/service/github/auth.dart';

class GithubClient {
  GithubClient();

  Future<GitHub> get github async {
    return GitHub(auth: Authentication.withToken(await const GithubAuthService().getToken()));
  }

  Future<Release> getLatestRelease(GitSource source) async {
    final repositorySlug = RepositorySlug(source.user, source.repository);
    return (await github).repositories.getLatestRelease(repositorySlug);
  }
}
