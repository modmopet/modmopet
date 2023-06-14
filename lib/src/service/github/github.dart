import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:github/github.dart';
import 'package:modmopet/src/entity/git_source.dart';
import 'package:modmopet/src/service/github/auth.dart';

class GithubClient {
  GithubClient();

  Future<GitHub> get github async {
    return GitHub(auth: Authentication.withToken(await const GithubAuthService().getToken()));
  }

  Future<Release> getLatestReleaseByGitSource(GitSource source) async {
    final repositorySlug = RepositorySlug(source.user, source.repository);
    return (await github).repositories.getLatestRelease(repositorySlug);
  }

  Future<Release> getLatestReleaseBySlug(RepositorySlug slug) async {
    return (await github).repositories.getLatestRelease(slug);
  }

  Future<ReleaseNotes> generateReleaseNotes(String latestVersion, String currentVersion) async {
    final RepositorySlug slug = RepositorySlug('modmopet', 'modmopet');
    debugPrint(latestVersion);
    debugPrint(currentVersion);
    CreateReleaseNotes releaseNotesFrom = CreateReleaseNotes(
      slug.owner,
      slug.name,
      latestVersion,
      previousTagName: currentVersion,
    );
    return await (await github).repositories.generateReleaseNotes(releaseNotesFrom);
  }
}
