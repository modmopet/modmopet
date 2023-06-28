import 'dart:io';
import 'package:ini/ini.dart';
import 'package:modmopet/src/entity/emulator.dart';
import 'package:modmopet/src/entity/game_meta.dart';
import 'package:modmopet/src/service/filesystem/emulator_filesystem.dart';
import 'package:modmopet/src/service/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class YuzuFilesystem extends EmulatorFilesystem implements EmulatorFilesystemInterface {

  Config? options;

  YuzuFilesystem._(){
    File? ini;
    if(Platform.isWindows){
      ini = File("%AppData%\\yuzu\\config\\qt-config.ini");
    }else if (Platform.isLinux){
      ini = File(path.join(Platform.environment['HOME']!, ".config/yuzu/qt-config.ini"));
      if(!ini.existsSync()){
        ini = File(path.join(Platform.environment['HOME']!, ".var/app/org.yuzu_emu.yuzu/config/yuzu/qt-config.ini"));
      }
    }else{
      //TODO: Other platforms
    }
    if(ini != null && ini.existsSync()){
      options = Config.fromString(ini.readAsStringSync());
    }
  }
  static final instance = YuzuFilesystem._();
  static const String emulatorId = 'yuzu';
  static const String applicationFolderName = 'yuzu';
  static const String identifierDirectory = 'load';
  static const String modsDirectoryBasename = 'load';
  static final String gamesDirectoryBasename = path.join('cache', 'game_list');
  static final Map<String, List<String>> gamesAlternativePaths = {
    'windows': [
      '%AppData%\\Roaming\\yuzu\\cache\\game_list',
    ],
    'linux': [
      '${Platform.environment['HOME']}/.cache/yuzu/game_list',
      '${Platform.environment['HOME']}/.var/app/org.yuzu_emu.yuzu/cache/yuzu/game_list' // KDE Discovery
    ],
    'macos': [
      '${Platform.environment['HOME']}/Library/Caches/yuzu/game_list',
    ],
  };

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
    if(options != null){
      var loadPath = options!.get("Data%20Storage", "load_directory");
      if(loadPath != null){
        return Directory(path.joinAll([
          loadPath,
          gameTitleId,
          modFolderBasename,
        ]));
      }
    }
    final modDirectory = Directory(path.joinAll([
      emulator.path,
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
    final Directory emulatorAppDirectory = Directory(emulator.path);
    if (await emulatorAppDirectory.exists()) {
      final Directory modDirectory = Directory(
        path.joinAll([
          emulatorAppDirectory.path,
          identifierDirectory,
          gameTitleId,
        ]),
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
    final Directory emulatorAppDirectory = Directory(emulator.path);
    final gameDirectory = Directory(path.joinAll([emulatorAppDirectory.path, gamesDirectoryBasename, gameTitleId]));

    return gameDirectory;
  }

  Future<Directory?> _getDirectory(String path) async {
    final Directory directory = Directory(path);
    if (await directory.exists()) {
      return directory;
    } else {
      return null;
    }
  }

  @override
  Future<Stream<FileSystemEntity>> getGamesDirectoryList(Emulator emulator) async {
    final Directory? emulatorAppDirectory = await _getDirectory(emulator.path);

    if (emulatorAppDirectory == null) {
      return const Stream<FileSystemEntity>.empty();
    }

    String gameListPath = path.join(emulatorAppDirectory.path, gamesDirectoryBasename);
    Directory? gameListDirectory = await _getDirectory(gameListPath);

    if (gameListDirectory == null) {
      for (String alternativePath in gamesAlternativePaths[Platform.operatingSystem]!) {
        gameListDirectory = await _getDirectory(alternativePath);
        if (gameListDirectory != null) {
          break;
        }
      }
    }

    return gameListDirectory != null ? gameListDirectory.list() : const Stream<FileSystemEntity>.empty();
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
