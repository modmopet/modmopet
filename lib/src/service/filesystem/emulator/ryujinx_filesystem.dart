import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/service/filesystem/emulator_filesystem_interface.dart';
import 'package:path_provider/path_provider.dart';

class RyujinxFilesystem extends ChangeNotifier implements EmulatorFilesystemInterface {
  RyujinxFilesystem._();

  static final instance = RyujinxFilesystem._();
  static const String identifierDirectory = 'games';

  String applicationFolderPath = '';
  final String _applicationFolderName = 'Ryujinx';
  final String _gameListPath = 'games';

  Future<Directory> _emulatorDirectory() async {
    final modMopetFolder = await getApplicationSupportDirectory();
    return Directory('${modMopetFolder.path}/../$_applicationFolderName');
  }

  @override
  Future<Stream<FileSystemEntity>> modDirectoryList(Game game, {bool recursive = false}) async {
    final Directory emulatorModDirectory = await _emulatorDirectory();
    final Directory modDirectory = Directory(emulatorModDirectory.path + Platform.pathSeparator + game.id);
    return modDirectory.list(recursive: recursive);
  }

  @override
  Future<Stream<FileSystemEntity>> gameFileList() async {
    final Directory emulatorModDirectory = await _emulatorDirectory();
    final Directory gameListDirectory = Directory(emulatorModDirectory.path + Platform.pathSeparator + _gameListPath);
    return gameListDirectory.list();
  }

  @override
  Future<void> setApplicationFolderPath(String path) async {
    applicationFolderPath = path;
    notifyListeners();
  }
}
