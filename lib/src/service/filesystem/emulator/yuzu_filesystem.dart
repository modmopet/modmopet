import 'dart:io';
import 'package:modmopet/src/entity/game.dart';
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
  final String _gameListPath = 'cache${Platform.pathSeparator}game_list';

  @override
  String getIdentifier() => identifierDirectory;

  @override
  Future<Directory> defaultEmulatorAppDirectory() async {
    Directory applicationSupportDirectory = await getApplicationSupportDirectory();
    return Directory(
        '${applicationSupportDirectory.path}${Platform.pathSeparator}..${Platform.pathSeparator}$applicationFolderName');
  }

  @override
  Future<Stream<FileSystemEntity>> getModDirectoryList(Game game, {bool recursive = false}) async {
    final Directory emulatorAppDirectory = await defaultEmulatorAppDirectory();
    if (await emulatorAppDirectory.exists()) {
      final Directory modDirectory = Directory(emulatorAppDirectory.path + Platform.pathSeparator + game.id);
      return modDirectory.list(recursive: recursive);
    }

    return const Stream<FileSystemEntity>.empty();
  }

  @override
  Future<Stream<FileSystemEntity>> getGameFileList() async {
    final Directory emulatorAppDirectory = await defaultEmulatorAppDirectory();
    if (await emulatorAppDirectory.exists()) {
      final Directory gameListDirectory = Directory(emulatorAppDirectory.path + Platform.pathSeparator + _gameListPath);
      return gameListDirectory.list();
    }

    return const Stream<FileSystemEntity>.empty();
  }

  Future<bool> installMod(Mod mod) async {
    return true;
  }

  @override
  Future<bool> isIdentiedByDirectoryStructure(String emulatorDirectoryPath) async {
    final Directory emulatorDirectory = Directory(emulatorDirectoryPath);
    await for (var element in emulatorDirectory.list()) {
      if (element is Directory) {
        final directory = path.basename(element.path);
        if (directory == YuzuFilesystem.identifierDirectory) {
          LoggerService.instance.log('Yuzu application folder found at: $emulatorDirectoryPath');
          return true;
        }
      }
    }

    return false;
  }
}
