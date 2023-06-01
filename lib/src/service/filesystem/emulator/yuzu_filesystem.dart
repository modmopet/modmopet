import 'dart:io';
import 'package:modmopet/src/entity/mod.dart';
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
  static const String modsDirectoryBasename = 'mods';
  static final String gamesDirectoryBasename = 'cache${Platform.pathSeparator}game_list';

  @override
  String getIdentifier() => identifierDirectory;

  @override
  Future<Directory> defaultEmulatorAppDirectory() async {
    Directory applicationSupportDirectory = await getApplicationSupportDirectory();
    return Directory(
        '${applicationSupportDirectory.path}${Platform.pathSeparator}..${Platform.pathSeparator}$applicationFolderName');
  }

  /// Gets the directory of a potentially installed mod
  @override
  Future<Directory> getModDirectory(String gameTitleId, String basename) async {
    final Directory emulatorAppDirectory = await defaultEmulatorAppDirectory();
    final modDirectory = Directory(
      emulatorAppDirectory.path +
          Platform.pathSeparator +
          modsDirectoryBasename +
          Platform.pathSeparator +
          gameTitleId +
          Platform.pathSeparator +
          basename,
    );

    return modDirectory;
  }

  @override
  Future<List<FileSystemEntity>> getModsDirectoryList(String gameTitleId, {bool recursive = false}) async {
    final Directory emulatorAppDirectory = await defaultEmulatorAppDirectory();
    if (await emulatorAppDirectory.exists()) {
      final Directory modDirectory = Directory(
        emulatorAppDirectory.path + Platform.pathSeparator + identifierDirectory + Platform.pathSeparator + gameTitleId,
      );
      return modDirectory.list(recursive: recursive).toList();
    }

    return [];
  }

  @override
  Future<Directory> getGameDirectory(String gameTitleId) async {
    final Directory emulatorAppDirectory = await defaultEmulatorAppDirectory();
    final gameDirectory = Directory(
      emulatorAppDirectory.path +
          Platform.pathSeparator +
          gamesDirectoryBasename +
          Platform.pathSeparator +
          gameTitleId,
    );

    return gameDirectory;
  }

  @override
  Future<Stream<FileSystemEntity>> getGamesDirectoryList() async {
    final Directory emulatorAppDirectory = await defaultEmulatorAppDirectory();
    if (await emulatorAppDirectory.exists()) {
      final Directory gameListDirectory =
          Directory(emulatorAppDirectory.path + Platform.pathSeparator + gamesDirectoryBasename);
      return gameListDirectory.list();
    }

    return const Stream<FileSystemEntity>.empty();
  }

  Future<bool> installMod(Mod mod) async {
    return true;
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
