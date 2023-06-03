import 'dart:io';
import 'package:modmopet/src/service/filesystem/emulator_filesystem.dart';
import 'package:modmopet/src/service/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class RyujinxFilesystem extends EmulatorFilesystem implements EmulatorFilesystemInterface {
  RyujinxFilesystem._();
  static final instance = RyujinxFilesystem._();
  static const String emulatorId = 'ryujinx';
  static const String applicationFolderName = 'Ryujinx';
  static const String identifierDirectory = 'games';
  static const String modsDirectoryBasename = 'mods';
  static const String gamesDirectoryBasename = 'games';

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
  Future<Directory> getModDirectory(String gameTitleId, String modUid) async {
    final Directory emulatorAppDirectory = await defaultEmulatorAppDirectory();
    final modDirectory = Directory(
      '${emulatorAppDirectory.path}${Platform.pathSeparator}$modsDirectoryBasename${Platform.pathSeparator}contents${Platform.pathSeparator}$gameTitleId${Platform.pathSeparator}$mmPrefix$modUid',
    );

    return modDirectory;
  }

  // Gets a list of all directories inside the mod folder of the emulator
  @override
  Future<List<FileSystemEntity>> getModsDirectoryList(String gameTitleId, {bool recursive = false}) async {
    final Directory emulatorAppDirectory = await defaultEmulatorAppDirectory();
    if (emulatorAppDirectory.existsSync()) {
      final Directory modDirectory = Directory(
        '${emulatorAppDirectory.path}${Platform.pathSeparator}$modsDirectoryBasename${Platform.pathSeparator}contents${Platform.pathSeparator}${gameTitleId.toUpperCase()}',
      );

      if (await modDirectory.exists()) {
        final modDirectoryList = modDirectory.list(recursive: recursive);
        return modDirectoryList.toList();
      }
    }

    return [];
  }

  @override
  Future<Directory> getGameDirectory(String gameId) async {
    final Directory emulatorAppDirectory = await defaultEmulatorAppDirectory();
    final gameDirectory = Directory(
      emulatorAppDirectory.path + Platform.pathSeparator + gamesDirectoryBasename + Platform.pathSeparator + gameId,
    );

    return gameDirectory;
  }

  /// Gets the games metadata directory of the emulator to identify the installed games by titleId
  @override
  Future<Stream<FileSystemEntity>> getGamesDirectoryList() async {
    final Directory emulatorAppDirectory = await defaultEmulatorAppDirectory();
    if (emulatorAppDirectory.existsSync()) {
      final Directory gameListDirectory = Directory(
        emulatorAppDirectory.path + Platform.pathSeparator + gamesDirectoryBasename,
      );
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
          LoggerService.instance.log('Filesystem: $emulatorId application folder found at: $emulatorDirectoryPath');
          return true;
        }
      }
    }

    return false;
  }
}
