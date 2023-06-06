import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modmopet/src/entity/emulator.dart';
import 'package:modmopet/src/entity/mod.dart';
import 'package:modmopet/src/extensions.dart';

class ModService {
  ModService._();
  static final instance = ModService._();

  Future<void> installMod(
      String gameTitleId, Mod mod, Emulator emulator) async {
    final modSourceDirectory = Directory(mod.origin);
    final titleId = gameTitleId.toUpperCase();
    final emulatorModDirectory =
        await emulator.filesystem.getModDirectory(emulator, titleId, mod.id);

    if (await emulatorModDirectory.exists() == false) {
      await emulatorModDirectory.create();
    }

    modSourceDirectory.copyTo(emulatorModDirectory);
  }

  Future<void> updateMod(String gameTitleId, Mod mod, Emulator emulator) async {
    installMod(gameTitleId, mod, emulator);
  }

  Future<void> removeMod(String gameTitleId, Mod mod, Emulator emulator) async {
    final emulatorModDirectory = await emulator.filesystem
        .getModDirectory(emulator, gameTitleId, mod.id);
    debugPrint(emulatorModDirectory.path);
    await emulatorModDirectory.delete(recursive: true);
  }
}
