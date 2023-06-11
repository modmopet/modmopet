import 'dart:convert';
import 'dart:io';
import 'package:modmopet/src/entity/emulator.dart';
import 'package:modmopet/src/entity/game_meta.dart';
import 'package:modmopet/src/service/filesystem/emulator_filesystem.dart';
import 'package:modmopet/src/service/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class RyujinxFilesystem extends EmulatorFilesystem
    implements EmulatorFilesystemInterface {
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
    Directory applicationSupportDirectory =
        await getApplicationSupportDirectory();
    return Directory(
      '${applicationSupportDirectory.path}${Platform.pathSeparator}..${Platform.pathSeparator}$applicationFolderName',
    );
  }

  /// Gets the directory of a potentially installed mod
  @override
  Future<Directory> getModDirectory(
      Emulator emulator, String gameTitleId, String identifier) async {
    final modDirectory = Directory(
      '${emulator.path!}${Platform.pathSeparator}$modsDirectoryBasename${Platform.pathSeparator}contents${Platform.pathSeparator}$gameTitleId${Platform.pathSeparator}$mmPrefix$identifier',
    );

    return modDirectory;
  }

  // Gets a list of all directories inside the mod folder of the emulator
  @override
  Future<List<FileSystemEntity>> getModsDirectoryList(
    Emulator emulator,
    String gameTitleId, {
    bool recursive = false,
  }) async {
    final Directory emulatorAppDirectory = Directory(emulator.path!);
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
  Future<Directory> getGameDirectory(Emulator emulator, String gameId) async {
    final Directory emulatorAppDirectory = Directory(emulator.path!);
    final gameDirectory = Directory(
      emulatorAppDirectory.path +
          Platform.pathSeparator +
          gamesDirectoryBasename +
          Platform.pathSeparator +
          gameId,
    );

    return gameDirectory;
  }

  /// Gets the games metadata directory of the emulator to identify the installed games by titleId
  @override
  Future<Stream<FileSystemEntity>> getGamesDirectoryList(
      Emulator emulator) async {
    final Directory emulatorAppDirectory = Directory(emulator.path!);
    if (emulatorAppDirectory.existsSync()) {
      final Directory gameListDirectory = Directory(
        emulatorAppDirectory.path +
            Platform.pathSeparator +
            gamesDirectoryBasename,
      );
      return gameListDirectory.list();
    }

    return const Stream<FileSystemEntity>.empty();
  }

  /// Gets the game metadata from the emulator to display info about the playtime and other things
  @override
  Future<GameMeta?> getGameMetadata(
      Emulator emulator, String gameTitleId) async {
    final Directory emulatorGameDirectory =
        await getGameDirectory(emulator, gameTitleId);
    if (emulatorGameDirectory.existsSync()) {
      final File gameMetaFile = File(
        '${emulatorGameDirectory.path}${Platform.pathSeparator}gui${Platform.pathSeparator}metadata.json',
      );

      if (gameMetaFile.existsSync()) {
        final Map<String, dynamic> metaData =
            await jsonDecode(gameMetaFile.readAsStringSync());
        return GameMeta(
          title: metaData.containsKey('title') ? metaData['title']! : '',
          favorite: metaData.containsKey('favorite')
              ? metaData['favorite']! as bool
              : false,
          playTime: metaData.containsKey('time_played')
              ? metaData['time_played']! as int
              : 0,
          lastPlayed: metaData.containsKey('last_played_utc')
              ? DateTime.tryParse(metaData['last_played_utc'])
              : null,
        );
      }
    }

    return null;
  }

  @override
  Future<bool> isIdentifiedByDirectoryStructure(
      String emulatorDirectoryPath) async {
    final Directory emulatorDirectory = Directory(emulatorDirectoryPath);
    await for (var element in emulatorDirectory.list()) {
      if (element is Directory) {
        final directory = path.basename(element.path);
        if (directory == identifierDirectory) {
          LoggerService.instance.log(
              'Filesystem: $emulatorId application folder found at: $emulatorDirectoryPath');
          return true;
        }
      }
    }

    return false;
  }
}
