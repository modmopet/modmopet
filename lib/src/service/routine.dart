import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/entity/git_source.dart';
import 'package:modmopet/src/service/github.dart';
import 'package:modmopet/src/service/filesystem/platform_filesystem.dart';
import 'package:modmopet/src/service/logger.dart';

class AppRoutineService {
  AppRoutineService._();

  static final instance = AppRoutineService._();

  Future<void> checkAppHealth() async {
    // _doAppDirectoryRoutine();
  }

  Future<void> checkTitlesDatabase() async {
    File titlesJsonFile = await PlatformFilesystem.instance.getFile('titles.json');
    if (!await titlesJsonFile.exists()) {
      final response = await Dio().download(
          'https://github.com/arch-box/titledb/releases/download/latest/titles.US.en.json', titlesJsonFile.path);

      if (response.statusCode == 200) {
        LoggerService.instance.log('Check title database: Download successfull...');
      } else {
        LoggerService.instance.log('Failed to download titles database with code: ${response.statusCode}');
      }
    }
  }

  Future<void> checkForUpdates(Game game) async {
    for (GitSource source in game.sources) {
      // LoggerService.instance.log('Update Manager: Update source ${source.uri}');
      await _doUpdateIteration(game, source);
    }
  }

  Future<void> _doUpdateIteration(Game game, GitSource source) async {
    String? latestGithubCommitHash = await GithubService.instance.getLatestCommitHash(source);
    String? latestCommitHash = await PlatformFilesystem.instance.readFromLocal('latestCommitHash');

    if (latestGithubCommitHash == null) {
      LoggerService.instance.log('Update Manager: Error. Unable to get latest commit hash.');
    } else if (latestCommitHash == null) {
      LoggerService.instance.log('Update Manager: No local commit hash file found. Updating.');
      await _doUpdateCommitHashFile(latestGithubCommitHash);
      await _doDownloadAndSaveArchive(game, source);
    } else if (latestCommitHash != latestGithubCommitHash) {
      LoggerService.instance.log('Update Manager: New mods changes available! Update.');
      await _doUpdateCommitHashFile(latestGithubCommitHash);
      await _doDownloadAndSaveArchive(game, source);
      LoggerService.instance.log('Update Manager: Update successful!');
    } else {
      LoggerService.instance.log('Update Manager: No need to update.');
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
