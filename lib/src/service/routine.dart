import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/entity/git_source.dart';
import 'package:modmopet/src/service/github.dart';
import 'package:modmopet/src/service/filesystem/platform_filesystem.dart';
import 'package:modmopet/src/service/logger.dart';
import 'package:path_provider/path_provider.dart';

class AppRoutineService {
  AppRoutineService._();

  static final instance = AppRoutineService._();

  Future<void> checkAppHealth() async {
    _doAppDirectoryRoutine();
  }

  Future<void> checkForUpdate(Game game, GitSource source) async {
    String? latestGithubCommitHash = await GithubService.instance.getLatestCommitHash(source);
    String? latestCommitHash = await PlatformFilesystem.instance.readFromLocal('latestCommitHash');

    if (latestGithubCommitHash == null) {
      LoggerService.instance.log('CheckForUpdate: Error. Unable to get latest commit hash.');
    } else if (latestCommitHash == null) {
      LoggerService.instance.log('CheckForUpdate: No local commit hash file found. Updating.');
      await _doUpdateCommitHashFile(latestGithubCommitHash);
      await _doDownloadAndSaveArchive(game, source);
    } else if (latestCommitHash != latestGithubCommitHash) {
      LoggerService.instance.log('CheckForUpdate: New mods changes available! Update.');
      await _doUpdateCommitHashFile(latestGithubCommitHash);
      await _doDownloadAndSaveArchive(game, source);
      LoggerService.instance.log('CheckForUpdate: Update successful!');
    } else {
      LoggerService.instance.log('No need to update.');
    }
  }

  Future<void> _doUpdateCommitHashFile(String latestGithubCommitHash) async {
    PlatformFilesystem.instance.writeForLocal('latestCommitHash', latestGithubCommitHash, replace: true);
  }

  Future<void> _doDownloadAndSaveArchive(Game game, GitSource source) async {
    final Directory gameRootDirectory = await PlatformFilesystem.instance.gameRootDirectory(game.id);
    final File zipballFile = await PlatformFilesystem.instance
        .getUserFile('${gameRootDirectory.path}${Platform.pathSeparator}${source.branch}.zip');

    if (!await gameRootDirectory.exists()) {
      await PlatformFilesystem.instance.createDirectory(gameRootDirectory, replace: true);
    }

    // Download, extract, delete zipfile
    LoggerService.instance.log('CheckForUpdates: Downloading zipball...');
    final response = await Dio().download(
      '${source.uri}/archive/refs/heads/${source.branch}.zip',
      zipballFile.path,
    );

    if (response.statusCode == 200) {
      LoggerService.instance.log('CheckForUpdate: Downloading successfull...');
      LoggerService.instance.log('CheckForUpdate: Cleanup folder...');
      final Directory sourceFolder = Directory(
        '${gameRootDirectory.path}${Platform.pathSeparator}${source.repository}-${source.branch}',
      );

      if (await sourceFolder.exists()) {
        sourceFolder.delete();
      }

      await unzipSource(zipballFile, gameRootDirectory);
    }
  }

  Future<void> _doAppDirectoryRoutine() async {
    debugPrint('HealthCheck: Process directory routines.');
    Directory appData = await getApplicationSupportDirectory();
    Directory appFolder = Directory('${appData.path}/ModUI');
    if (!await appFolder.exists()) {
      LoggerService.instance.log(
        'Application Support directory missing! Create folder at: ${appData.path}',
      );
      appFolder.create();
    }
  }

  Future<void> unzipSource(File zipFile, Directory gameRootDirectory) async {
    final InputFileStream inputStream = InputFileStream(zipFile.path);
    final Archive archive = ZipDecoder().decodeBuffer(inputStream);
    LoggerService.instance.log('CheckForUpdate: Unzip zipball...');
    extractArchiveToDisk(archive, '${gameRootDirectory.path}/source');
    if (zipFile.existsSync()) {
      LoggerService.instance.log('CheckForUpdate: Delete unzipped zipball...');
      await zipFile.delete();
    }
  }
}
