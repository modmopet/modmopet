import 'dart:io';
import 'package:modmopet/src/entity/game.dart';

abstract interface class EmulatorFilesystemInterface {
  Future<Directory> defaultEmulatorAppDirectory();
  Future<Stream<FileSystemEntity>> getModDirectoryList(Game game, {bool recursive = false});
  Future<Stream<FileSystemEntity>> getGameFileList();
  Future<bool> isIdentiedByDirectoryStructure(String emulatorDirectoryPath);
  String getIdentifier();
}

abstract class EmulatorFilesystem implements EmulatorFilesystemInterface {}
