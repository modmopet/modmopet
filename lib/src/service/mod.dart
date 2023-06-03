import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:modmopet/src/entity/mod.dart';
import 'package:modmopet/src/service/filesystem/emulator_filesystem.dart';

class ModService {
  ModService._();
  static final instance = ModService._();

  Future<void> installMod(String gameTitleId, Mod mod, EmulatorFilesystemInterface filesystem) async {
    final modSourceDirectory = Directory(mod.origin);
    final titleId = gameTitleId.toUpperCase();
    final emulatorModDirectory = await filesystem.getModDirectory(titleId, mod.id);

    // Zip a directory to mod.zip using the zipDirectory convenience method
    var encoder = ZipFileEncoder();
    encoder.zipDirectory(modSourceDirectory);
    File modZip = File('${modSourceDirectory.path}.zip');

    // Uzip mod into emulator mod folder of the game
    await _unzipMod(modZip, emulatorModDirectory);
  }

  Future<void> updateMod(String gameTitleId, Mod mod, EmulatorFilesystemInterface filesystem) async {
    installMod(gameTitleId, mod, filesystem);
  }

  Future<void> removeMod(String gameTitleId, Mod mod, EmulatorFilesystemInterface filesystem) async {
    final emulatorModDirectory = await filesystem.getModDirectory(gameTitleId, mod.id);
    debugPrint(emulatorModDirectory.path);
    await emulatorModDirectory.delete(recursive: true);
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
