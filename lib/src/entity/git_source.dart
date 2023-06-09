import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/entity/mod.dart';
import 'package:modmopet/src/service/filesystem/platform_filesystem.dart';
import 'package:modmopet/src/service/github/github.dart';
import 'package:modmopet/src/service/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'git_source.freezed.dart';
part 'git_source.g.dart';

@freezed
class GitSource with _$GitSource {
  const GitSource._();
  const factory GitSource({
    required String user,
    required String repository,
    required String root,
    required String branch,
  }) = _GitSource;

  String get uri => 'https://github.com/$user/$repository';
}

@riverpod
class GitSources extends _$GitSources {
  @override
  List<GitSource> build() {
    final game = ref.watch(gameProvider);
    return game != null ? game.sources : [];
  }

  void addSource(GitSource source) {
    state = [...state, source];
  }

  void removeSource(GitSource source) {
    state = [
      for (final element in state)
        if (element != source) source,
    ];
  }
}

@riverpod
class SelectedSource extends _$SelectedSource {
  @override
  GitSource? build() {
    final availableSources = ref.watch(gitSourcesProvider);
    return availableSources.isNotEmpty ? availableSources.first : null;
  }

  void select(GitSource source) {
    state = source;
  }

  void clear() => state = null;
}

@riverpod
Future<void> updateSources(UpdateSourcesRef ref) async {
  final game = ref.watch(gameProvider);
  final availableGitSources = ref.watch(gitSourcesProvider);
  final selectedSource = ref.watch(selectedSourceProvider);

  // Only check for update if game has configured sources
  if (availableGitSources.isNotEmpty) {
    await _doUpdateIteration(game!.id, selectedSource ?? availableGitSources.first, ref);
  }
}

Future<void> _doUpdateIteration(String gameTitleId, GitSource source, FutureProviderRef ref) async {
  debugPrint('Check for new update');
  final latestRelease = await GithubClient().getLatestRelease(source);
  final latestGithubReleaseId = latestRelease.id;
  String? latestReleaseId = await PlatformFilesystem.instance.readFromLocal('latestReleaseId');

  if (latestGithubReleaseId == null) {
    LoggerService.instance.log('Update Manager: Error. Unable to get latest release id.');
  } else if (latestReleaseId == null) {
    LoggerService.instance.log('Update Manager: No local release id file found. Updating.');

    // Write release id to file and download the archive from github
    await _doUpdateReleaseIdFile(latestGithubReleaseId);
    await _doDownloadAndSaveArchive(gameTitleId, source);

    // Refresh mods after archive was unzipped and moved to mods folder
    ref.invalidate(modsProvider);
  } else if (latestReleaseId != latestGithubReleaseId.toString()) {
    LoggerService.instance.log('Update Manager: Udpate available!');

    //
    await _doUpdateReleaseIdFile(latestGithubReleaseId);
    await _doDownloadAndSaveArchive(gameTitleId, source);
    await LoggerService.instance.log('Update Manager: Update successful!');
    ref.invalidate(modsProvider);
    await LoggerService.instance.log('Invalidate mods');
  } else {
    LoggerService.instance.log('Update Manager: No need to update.');
  }
}

Future<void> _doUpdateReleaseIdFile(int latestGithubReleaseId) async {
  PlatformFilesystem.instance.writeForLocal('latestReleaseId', latestGithubReleaseId.toString(), replace: true);
}

Future<void> _doDownloadAndSaveArchive(String gameTitleId, GitSource source) async {
  final Directory gameRootDirectory = await PlatformFilesystem.instance.gameRootDirectory(gameTitleId.toUpperCase());
  if (!await gameRootDirectory.exists()) {
    await PlatformFilesystem.instance.createDirectory(gameRootDirectory, replace: true);
  }

  // Download, extract, delete zipfile
  LoggerService.instance.log('Update Manager: Downloading zipball...');
  final latestRelease = await GithubClient().getLatestRelease(source);

  // Try to find asset by name, since we want the full release
  final releaseAssets = latestRelease.assets;
  final fullReleaseAsset = releaseAssets?.singleWhere((element) => element.name!.contains('full.zip'));
  if (fullReleaseAsset != null) {
    final File zipballFile = File(
      '${gameRootDirectory.path}${Platform.pathSeparator}${fullReleaseAsset.name}.zip',
    );
    final response = await Dio().download(fullReleaseAsset.browserDownloadUrl!, zipballFile.path);

    if (response.statusCode == 200) {
      LoggerService.instance.log('Update Manager: Downloading successfull...');
      LoggerService.instance.log('Update Manager: Cleanup folder...');
      final Directory sourceFolder = Directory(
        '${gameRootDirectory.path}${Platform.pathSeparator}source${Platform.pathSeparator}${source.repository}',
      );

      if (await sourceFolder.exists()) {
        sourceFolder.delete(recursive: true);
      }

      await _unzipSource(zipballFile, sourceFolder);
    }
  }
}

Future<void> _unzipSource(File zipFile, Directory to) async {
  final InputFileStream inputStream = InputFileStream(zipFile.path);
  final Archive archive = ZipDecoder().decodeBuffer(inputStream);
  LoggerService.instance.log('Update Manager: Unzip zipball...');

  // Extract archive to given directory path
  extractArchiveToDisk(archive, to.path);
  inputStream.close();

  // Delete old zip file after file extraction
  if (await zipFile.exists()) {
    LoggerService.instance.log('Update Manager: Delete unzipped zipball...');
    await zipFile.delete();
  }
}
