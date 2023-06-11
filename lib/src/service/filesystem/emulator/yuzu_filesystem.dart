import 'dart:io';
import 'package:modmopet/src/entity/emulator.dart';
import 'package:modmopet/src/entity/game_meta.dart';
import 'package:modmopet/src/service/filesystem/emulator_filesystem.dart';
import 'package:modmopet/src/service/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class YuzuFilesystem extends EmulatorFilesystem implements EmulatorFilesystemInterface {
  YuzuFilesystem._();
  static final instance = YuzuFilesystem._();
  static const String emulatorId = 'yuzu';
  static const String applicationFolderName = 'yuzu';
  static const String identifierDirectory = 'load';
  static const String modsDirectoryBasename = 'load';
  static final String gamesDirectoryBasename = path.join('cache', 'game_list');

  @override
  String getIdentifier() => identifierDirectory;

  @override
  Future<Directory> defaultEmulatorAppDirectory() async {
    Directory applicationSupportDirectory = (await getApplicationSupportDirectory()).parent;
    return Directory(path.join(applicationSupportDirectory.path, applicationFolderName));
  }

  /// Gets the directory of a potentially installed mod
  @override
  Future<Directory> getModDirectory(Emulator emulator, String gameTitleId, String identifier) async {
    final modFolderBasename = mmPrefix + identifier;
    final modDirectory = Directory(path.joinAll([
      emulator.path!,
      modsDirectoryBasename,
      gameTitleId,
      modFolderBasename,
    ]));

    return modDirectory;
  }

  @override
  Future<List<FileSystemEntity>> getModsDirectoryList(
    Emulator emulator,
    String gameTitleId, {
    bool recursive = false,
  }) async {
    final Directory emulatorAppDirectory = Directory(emulator.path!);
    if (await emulatorAppDirectory.exists()) {
      final Directory modDirectory = Directory(
        emulatorAppDirectory.path + Platform.pathSeparator + identifierDirectory + Platform.pathSeparator + gameTitleId,
      );

      if (await modDirectory.exists()) {
        final modDirectoryList = modDirectory.list(recursive: recursive);
        return modDirectoryList.toList();
      }
    }

    return [];
  }

  // Yuzu does not support game metadata yet
  @override
  Future<GameMeta?> getGameMetadata(Emulator emulator, String gameTitleId) async {
    return null;
  }

  @override
  Future<Directory> getGameDirectory(Emulator emulator, String gameTitleId) async {
    final Directory emulatorAppDirectory = Directory(emulator.path!);
    final gameDirectory = Directory(path.joinAll([emulatorAppDirectory.path, gamesDirectoryBasename, gameTitleId]));

    return gameDirectory;
  }

  @override
  Future<Stream<FileSystemEntity>> getGamesDirectoryList(Emulator emulator) async {
    final Directory emulatorAppDirectory = Directory(emulator.path!);
    if (await emulatorAppDirectory.exists()) {
      final Directory gameListDirectory = Directory(path.join(emulatorAppDirectory.path, gamesDirectoryBasename));
      if (!await gameListDirectory.exists()) {
        return const Stream<FileSystemEntity>.empty();
      }
      return gameListDirectory.list();
    }

    return const Stream<FileSystemEntity>.empty();
  }

  @override
  Future<bool> isIdentifiedByDirectoryStructure(String emulatorDirectoryPath) async {
    final Directory emulatorDirectory = Directory(emulatorDirectoryPath);
    await for (var element in emulatorDirectory.list()) {
      if (element is Directory) {
        final directory = path.basename(element.path);
        if (directory == identifierDirectory) {
          LoggerService.instance.log('Yuzu application folder found at: $emulatorDirectoryPath');
          return true;
        }
      }
    }

    return false;
  }
}
