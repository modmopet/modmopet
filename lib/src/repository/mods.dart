import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modmopet/src/entity/emulator.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/entity/git_source.dart';
import 'package:modmopet/src/entity/mod.dart';
import 'package:modmopet/src/service/filesystem/emulator_filesystem.dart';
import 'package:modmopet/src/service/filesystem/platform_filesystem.dart';
import 'package:yaml/yaml.dart';

class ModsRepository {
  /// Checks a mods directory is installed to the emulators mod folder
  Future<bool> isModInstalled(EmulatorFilesystemInterface filesystem, String gameTitleId, String modId) async {
    final modDirectory = await filesystem.getModDirectory(gameTitleId.toUpperCase(), modId.toLowerCase());
    return await modDirectory.exists();
  }

  Future<bool> hasModUpdate(
      EmulatorFilesystemInterface filesystem, String gameTitleId, String modId, String modOrigin) async {
    final installedModDirectory = await filesystem.getModDirectory(gameTitleId.toUpperCase(), modId.toLowerCase());
    final int installedModVersion = getExtendedVersionNumber(await getModVersion(installedModDirectory.path));
    final int sourceModVersion = getExtendedVersionNumber(await getModVersion(modOrigin));

    debugPrint('Check for mod update: $installedModVersion vs $sourceModVersion');

    return sourceModVersion != installedModVersion;
  }

  Future<List<Mod>> getAvailableMods(Emulator emulator, Game game, GitSource source) async {
    final List<Mod> modList = List.empty(growable: true);

    Directory modsSourceDirectory = await PlatformFilesystem.instance.modsSourceDirectory(game, source);
    if (await modsSourceDirectory.exists()) {
      final Stream<FileSystemEntity> modDirectories = modsSourceDirectory.list(recursive: true);
      await for (var modDirectory in modDirectories.asBroadcastStream()) {
        final File modConfigYaml = File('${modDirectory.path}${Platform.pathSeparator}config.yaml');
        if (await modConfigYaml.exists()) {
          final content = await modConfigYaml.readAsString();
          var modConfig = await loadYaml(content);
          try {
            Mod mod = await parseModFromYaml(modConfig, modDirectory, emulator, game);

            modList.add(mod);
          } catch (e) {
            debugPrint('Config file format not valid, skip: $e');
          }
        }
      }
    }

    return modList;
  }

  Future<Mod> parseModFromYaml(
    dynamic yamlConfig,
    FileSystemEntity modDirectory,
    Emulator emulator,
    Game game,
  ) async {
    final bool isInstalled = await isModInstalled(emulator.filesystem, game.id, yamlConfig['id']);
    final bool hasUpdate = isInstalled == true
        ? await hasModUpdate(emulator.filesystem, game.id, yamlConfig['id'], modDirectory.path)
        : false;
    return Mod.fromYaml(yamlConfig, modDirectory.path, isInstalled: isInstalled, hasUpdate: hasUpdate);
  }

  /// Gets a version of a mod by its path
  Future<String> getModVersion(String path, {String configFileBasename = 'config.yaml'}) async {
    final directory = Directory(path);
    final File configYaml = File('${directory.path}${Platform.pathSeparator}$configFileBasename');
    final sourceModConfig = await loadYaml(await configYaml.readAsString());
    return sourceModConfig['version'];
  }

  int getExtendedVersionNumber(String version) {
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  }
}
