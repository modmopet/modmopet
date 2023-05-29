import 'dart:io';
import 'package:modmopet/src/entity/game.dart';
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
  final String _gameListPath = 'games';

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
    if (emulatorAppDirectory.existsSync()) {
      final Directory modDirectory = Directory(emulatorAppDirectory.path + Platform.pathSeparator + game.id);
      return modDirectory.list(recursive: recursive);
    }

    return const Stream<FileSystemEntity>.empty();
  }

  @override
  Future<Stream<FileSystemEntity>> getGameFileList() async {
    final Directory emulatorAppDirectory = await defaultEmulatorAppDirectory();
    if (emulatorAppDirectory.existsSync()) {
      final Directory gameListDirectory = Directory(emulatorAppDirectory.path + Platform.pathSeparator + _gameListPath);
      return gameListDirectory.list();
    }

    return const Stream<FileSystemEntity>.empty();
  }

  @override
  Future<bool> isIdentiedByDirectoryStructure(String emulatorDirectoryPath) async {
    final Directory emulatorDirectory = Directory(emulatorDirectoryPath);
    await for (var element in emulatorDirectory.list()) {
      if (element is Directory) {
        final directory = path.basename(element.path);
        if (directory == RyujinxFilesystem.identifierDirectory) {
          LoggerService.instance.log('Filesystem: $emulatorId application folder found at: $emulatorDirectoryPath');
          return true;
        }
      }
    }

    return false;
  }
}
