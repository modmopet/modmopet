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

    return sourceModVersion == installedModVersion;
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
            debugPrint('Config file ${modConfigYaml.path} format not valid, skip: $e');
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
    final String id = yamlConfig['id'];
    final String title = yamlConfig['title'];
    final int category = yamlConfig['category'];
    final dynamic version = yamlConfig['version'];
    final YamlMap gameMap = yamlConfig['game'];
    final String? subtitle = yamlConfig['subtitle'];
    final YamlList? authorList = yamlConfig['author'];
    final bool isInstalled = await isModInstalled(emulator.filesystem, game.id, id);
    final bool hasUpdate =
        isInstalled == true ? await hasModUpdate(emulator.filesystem, game.id, id, modDirectory.path) : false;

    return Mod(
      id: id,
      title: title,
      category: Category.values.singleWhere(
        (element) => element.id == category,
      ),
      version: version,
      game: gameMap.value,
      origin: modDirectory.path,
      subtitle: subtitle,
      isInstalled: isInstalled,
      hasUpdate: hasUpdate,
      author: authorList,
    );
  }

  /// Gets a version of a mod by its path
  Future<String> getModVersion(String modOriginPath, {String configFileBasename = 'config.yaml'}) async {
    final directory = Directory(modOriginPath);
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
