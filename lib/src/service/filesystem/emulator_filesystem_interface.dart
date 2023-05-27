import 'dart:io';
import 'package:modmopet/src/entity/game.dart';

abstract interface class EmulatorFilesystemInterface {
  Future<Stream<FileSystemEntity>> modDirectoryList(Game game, {bool recursive = false});
  Future<Stream<FileSystemEntity>> gameFileList();
  Future<void> setApplicationFolderPath(String path);
}
