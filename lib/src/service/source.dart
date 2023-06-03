import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/entity/git_source.dart';
import 'package:modmopet/src/entity/mod.dart';
import 'package:modmopet/src/service/github.dart';
import 'package:modmopet/src/service/filesystem/platform_filesystem.dart';
import 'package:modmopet/src/service/logger.dart';

class SourceService {
  SourceService._();
  static final instance = SourceService._();

  Future<void> checkForUpdates(Game game, WidgetRef ref) async {
    for (GitSource source in game.sources) {
      await _doUpdateIteration(game, source, ref);
    }
  }

  Future<void> _doUpdateIteration(Game game, GitSource source, WidgetRef ref) async {
    String? latestGithubCommitHash = await GithubService.instance.getLatestCommitHash(source);
    String? latestCommitHash = await PlatformFilesystem.instance.readFromLocal('latestCommitHash');

    if (latestGithubCommitHash == null) {
      LoggerService.instance.log('Update Manager: Error. Unable to get latest commit hash.');
    } else if (latestCommitHash == null) {
      LoggerService.instance.log('Update Manager: No local commit hash file found. Updating.');
      await _doUpdateCommitHashFile(latestGithubCommitHash);
      await _doDownloadAndSaveArchive(game, source);
      ref.invalidate(modsProvider);
      await LoggerService.instance.log('Invalidate mods');
    } else if (latestCommitHash != latestGithubCommitHash) {
      LoggerService.instance.log('Update Manager: New mods changes available! Update.');
      await _doUpdateCommitHashFile(latestGithubCommitHash);
      await _doDownloadAndSaveArchive(game, source);
      await LoggerService.instance.log('Update Manager: Update successful!');
      ref.invalidate(modsProvider);
      await LoggerService.instance.log('Invalidate mods');
    } else {
      LoggerService.instance.log('Update Manager: No need to update.');
    }
  }

  Future<void> _doUpdateCommitHashFile(String latestGithubCommitHash) async {
    PlatformFilesystem.instance.writeForLocal('latestCommitHash', latestGithubCommitHash, replace: true);
  }

  Future<void> _doDownloadAndSaveArchive(Game game, GitSource source) async {
    final Directory gameRootDirectory = await PlatformFilesystem.instance.gameRootDirectory(game.id.toUpperCase());
    final File zipballFile = await PlatformFilesystem.instance
        .getUserFile('${gameRootDirectory.path}${Platform.pathSeparator}${source.branch}.zip');

    if (!await gameRootDirectory.exists()) {
      await PlatformFilesystem.instance.createDirectory(gameRootDirectory, replace: true);
    }

    // Download, extract, delete zipfile
    LoggerService.instance.log('Update Manager: Downloading zipball...');
    final response = await Dio().download(
      '${source.uri}/archive/refs/heads/${source.branch}.zip',
      zipballFile.path,
    );

    if (response.statusCode == 200) {
      LoggerService.instance.log('Update Manager: Downloading successfull...');
      LoggerService.instance.log('Update Manager: Cleanup folder...');
      final Directory sourceFolder = Directory(
        '${gameRootDirectory.path}${Platform.pathSeparator}${source.repository}-${source.branch}',
      );

      if (await sourceFolder.exists()) {
        sourceFolder.delete();
      }

      await _unzipSource(zipballFile, gameRootDirectory);
    }
  }

  Future<void> _unzipSource(File zipFile, Directory gameRootDirectory) async {
    final InputFileStream inputStream = InputFileStream(zipFile.path);
    final Archive archive = ZipDecoder().decodeBuffer(inputStream);
    LoggerService.instance.log('Update Manager: Unzip zipball...');
    extractArchiveToDisk(archive, '${gameRootDirectory.path}/source');
    if (zipFile.existsSync()) {
      LoggerService.instance.log('Update Manager: Delete unzipped zipball...');
      await zipFile.delete();
    }
  }
}
