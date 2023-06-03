import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/entity/git_source.dart';
import 'package:path_provider/path_provider.dart';

class PlatformFilesystem {
  PlatformFilesystem._();

  static final instance = PlatformFilesystem._();

  Future<Directory> get _applicationDocumentsDirectory async {
    return await getApplicationDocumentsDirectory();
  }

  Future<Directory> get _applicationSupportDirectory async {
    return await getApplicationSupportDirectory();
  }

  Future<String> _localUserPath({String? dir}) async {
    final directory = await _applicationDocumentsDirectory;
    if (dir != null && dir.isNotEmpty) {
      return '${directory.path}${Platform.pathSeparator}$dir';
    }

    return directory.path;
  }

  Future<String> _localPath({String? dir}) async {
    final directory = await _applicationSupportDirectory;
    if (dir != null && dir.isNotEmpty) {
      return '${directory.path}${Platform.pathSeparator}$dir';
    }

    return directory.path;
  }

  Future<File> _localFile(String path) async {
    final localPath = await _localPath();
    return File('$localPath${Platform.pathSeparator}$path');
  }

  Future<File> _localUserFile(String path) async {
    final localUserPath = await _localUserPath();
    return File('$localUserPath${Platform.pathSeparator}$path');
  }

  Future<File> getFile(String path) async {
    return await _localFile(path);
  }

  Future<File> getUserFile(String path) async {
    return await _localUserFile(path);
  }

  Future<Directory> getDirectory(path) async {
    return Directory(path);
  }

  Future<Directory> gameRootDirectory(String gameId) async {
    final localPath = await _applicationSupportDirectory;
    final gameRootDirectoryPath = '${localPath.path}${Platform.pathSeparator}games${Platform.pathSeparator}$gameId';
    return Directory(gameRootDirectoryPath);
  }

  Future<Directory> modsSourceDirectory(Game game, GitSource source) async {
    final String sourceRoot = '${(await gameRootDirectory(game.id.toUpperCase())).path}${Platform.pathSeparator}source';
    final String repositoryFolderName = '${source.repository}-${source.branch}';
    final String modsRoot =
        sourceRoot + Platform.pathSeparator + repositoryFolderName + Platform.pathSeparator + source.root;
    return Directory(modsRoot);
  }

  Directory gameModsDirectorySync(Game game, GitSource source) {
    final String sourceRoot = '${(gameRootDirectory(game.id.toUpperCase()))}${Platform.pathSeparator}source';
    final String repositoryFolderName = '${source.repository}-${source.branch}';
    final String modsRoot =
        sourceRoot + Platform.pathSeparator + repositoryFolderName + Platform.pathSeparator + source.root;
    return Directory(modsRoot);
  }

  Future<void> createDirectory(Directory directory, {bool replace = false}) async {
    if (replace == true && await directory.exists()) {
      directory.delete();
    }

    try {
      directory.create(recursive: true);
    } catch (e) {
      debugPrint('Folder already exists.');
    }
  }

  Future<File> writeForLocal(
    String path,
    String content, {
    bool replace = false,
    bool recursive = false,
  }) async {
    final file = await _localFile(path);

    if (replace) {
      if (await file.exists()) {
        await file.delete();
      }

      await file.create(recursive: recursive);
    }

    return file.writeAsString(content);
  }

  Future<String?> readFromLocal(String path) async {
    try {
      final file = await _localFile(path);
      return await file.readAsString();
    } catch (e) {
      return null;
    }
  }

  Future<File> writeForUser(
    String path,
    String content, {
    bool replace = false,
    bool recursive = false,
  }) async {
    final file = await _localFile(path);

    if (replace) {
      await file.delete();
      await file.create(recursive: recursive);
    }

    return file.writeAsString(content);
  }

  Future<String?> readFromUser(String path) async {
    try {
      final file = await _localFile(path);
      return await file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
