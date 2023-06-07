import 'dart:io';

import 'package:modmopet/src/entity/emulator.dart';
import 'package:modmopet/src/entity/game_meta.dart';

abstract interface class EmulatorFilesystemInterface {
  Future<Directory> defaultEmulatorAppDirectory();
  Future<Directory> getGameDirectory(Emulator emulator, String gameTitleId);
  Future<Directory> getModDirectory(
      Emulator emulator, String gameTitleId, String path);
  Future<List<FileSystemEntity>> getModsDirectoryList(
    Emulator emulator,
    String gameTitleId, {
    bool recursive = false,
  });
  Future<GameMeta?> getGameMetadata(Emulator emulator, String gameTitleId);
  Future<Stream<FileSystemEntity>> getGamesDirectoryList(Emulator emulator);
  Future<bool> isIdentifiedByDirectoryStructure(String emulatorDirectoryPath);
  String getIdentifier();
}

abstract class EmulatorFilesystem implements EmulatorFilesystemInterface {
  final String mmPrefix = 'mm_';
}
