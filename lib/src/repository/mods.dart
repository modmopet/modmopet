import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modmopet/src/entity/emulator.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/entity/git_source.dart';
import 'package:modmopet/src/entity/mod.dart';
import 'package:modmopet/src/service/filesystem/platform_filesystem.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:yaml/yaml.dart';

class ModsRepository {
  /// Checks a mods directory is installed to the emulators mod folder
  Future<bool> isModInstalled(Emulator emulator, String gameTitleId, String identifier, String modId) async {
    final modDirectory = await emulator.filesystem.getModDirectory(emulator, gameTitleId.toUpperCase(), identifier);
    final configFile = File('${modDirectory.path}${Platform.pathSeparator}config.yaml');

    // Need to check id to
    if (await configFile.exists()) {
      final mmConfig = loadYaml(await configFile.readAsString());
      return mmConfig['id'] == modId;
    }

    return false;
  }

  Future<bool> hasModUpdate(Emulator emulator, String gameTitleId, String identfier, String modOrigin) async {
    final installedModDirectory =
        await emulator.filesystem.getModDirectory(emulator, gameTitleId.toUpperCase(), identfier.toLowerCase());
    final int installedModVersion = getExtendedVersionNumber(await getModVersion(installedModDirectory.path));
    final int sourceModVersion = getExtendedVersionNumber(await getModVersion(modOrigin));

    return sourceModVersion != installedModVersion;
  }

  Future<List<Mod>> getAvailableMods(Emulator emulator, Game game, GitSource source, AvailableModsRef ref) async {
    final List<Mod> modList = List.empty(growable: true);
    Set<String> uniqueGameVersions = {};

    Directory modsSourceDirectory = await PlatformFilesystem.instance.modsSourceDirectory(game, source);
    if (await modsSourceDirectory.exists()) {
      final Stream<FileSystemEntity> modDirectories = modsSourceDirectory.list(recursive: true);
      await for (var modDirectory in modDirectories.asBroadcastStream()) {
        final File modConfigYaml = File('${modDirectory.path}${Platform.pathSeparator}config.yaml');
        if (await modConfigYaml.exists()) {
          try {
            final content = await modConfigYaml.readAsString();
            var modConfig = await loadYaml(content);
            Mod mod = await parseModFromYaml(modConfig, modDirectory, emulator, game);
            modList.add(mod);
            uniqueGameVersions = createUniqueGameVersionSet(modConfig['game']['version']);
          } catch (e, stackTrace) {
            debugPrint('Error parsing mod config: $e from ${modConfigYaml.path}');
            Sentry.captureException(e, stackTrace: stackTrace);
          }
        }
      }
    }

    ref.read(gameVersionsProvider.notifier).state = uniqueGameVersions;

    return modList;
  }

  Future<Mod> parseModFromYaml(
    dynamic yamlConfig,
    FileSystemEntity modDirectory,
    Emulator emulator,
    Game game,
  ) async {
    final bool isInstalled = await isModInstalled(emulator, game.id, yamlConfig['title'], yamlConfig['id']);
    final bool hasUpdate =
        isInstalled == true ? await hasModUpdate(emulator, game.id, yamlConfig['title'], modDirectory.path) : false;
    return Mod.fromYaml(yamlConfig, modDirectory.path, isInstalled: isInstalled, hasUpdate: hasUpdate);
  }

  /// Gets a version of a mod by its path
  Future<String> getModVersion(String path, {String configFileBasename = 'config.yaml'}) async {
    final directory = Directory(path);
    final File configYaml = File('${directory.path}${Platform.pathSeparator}$configFileBasename');
    final sourceModConfig = await loadYaml(await configYaml.readAsString());
    return sourceModConfig['version'];
  }

  Future<String> getModId(String path, {String configFileBasename = 'config.yaml'}) async {
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

  Set<String> createUniqueGameVersionSet(List<dynamic> versions) {
    final Set<String> gameVersionSet = {};
    for (var version in versions) {
      try {
        gameVersionSet.add(version.toString());
      } catch (e) {
        debugPrint('Error parsing game version: $e');
        continue;
      }
    }
    return gameVersionSet;
  }
}
