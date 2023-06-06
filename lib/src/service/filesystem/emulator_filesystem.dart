import 'dart:io';

abstract interface class EmulatorFilesystemInterface {
  Future<Directory> defaultEmulatorAppDirectory();
  Future<Directory> getGameDirectory(String gameTitleId);
  Future<Directory> getModDirectory(String gameTitleId, String path);
  Future<List<FileSystemEntity>> getModsDirectoryList(String gameTitleId, {bool recursive = false});
  Future<Stream<FileSystemEntity>> getGamesDirectoryList();
  Future<bool> isIdentifiedByDirectoryStructure(String emulatorDirectoryPath);
  String getIdentifier();
}

abstract class EmulatorFilesystem implements EmulatorFilesystemInterface {
  final String mmPrefix = 'mm_';
}
