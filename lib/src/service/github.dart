import 'dart:async';
import 'package:github/github.dart';
import 'package:modmopet/src/entity/git_source.dart';

class GithubService {
  GithubService._();
  static final instance = GithubService._();
  final github = GitHub(auth: findAuthenticationFromEnvironment());

  Future<Release> getLatestRelease(GitSource source) async {
    final repositorySlug = RepositorySlug(source.user, source.repository);
    return await github.repositories.getLatestRelease(repositorySlug);
  }
}
