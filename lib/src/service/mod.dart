import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/entity/mod.dart';
import 'package:modmopet/src/service/filesystem/emulator_filesystem.dart';
import 'package:path/path.dart' as path;

class ModService {
  ModService._();
  static final instance = ModService._();

  Future<void> installMod(Game game, Mod mod, EmulatorFilesystemInterface filesystem) async {
    final modSourceDirectory = Directory(mod.path);
    final emulatorModDirectory = await filesystem.getModDirectory(game.id, path.basename(mod.path));

    // Zip a directory to mod.zip using the zipDirectory convenience method
    var encoder = ZipFileEncoder();
    encoder.zipDirectory(modSourceDirectory);
    File modZip = File('${modSourceDirectory.path}.zip');

    // Uzip mod into emulator mod folder of the game
    await _unzipMod(modZip, emulatorModDirectory);
  }

  void updateMod(Mod mod, EmulatorFilesystemInterface filesystem) async {}

  void removeMod(Mod mod, EmulatorFilesystemInterface filesystem) async {
    // do stuff
  }

  Future<void> _unzipMod(File zipFile, Directory to) async {
    final InputFileStream inputStream = InputFileStream(zipFile.path);
    final Archive archive = ZipDecoder().decodeBuffer(inputStream);
    extractArchiveToDisk(archive, to.path);
    if (zipFile.existsSync()) {
      await zipFile.delete();
    }
  }
}
