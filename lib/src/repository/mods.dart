import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modmopet/src/entity/emulator.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/entity/git_source.dart';
import 'package:modmopet/src/entity/mod.dart';
import 'package:modmopet/src/service/filesystem/emulator_filesystem.dart';
import 'package:modmopet/src/service/filesystem/platform_filesystem.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

class ModsRepository {
  Future<bool> isModInstalled(Game game, EmulatorFilesystemInterface filesystem, String modFolderPath) async {
    final modToInstallDirectoryName = path.basename(modFolderPath);
    final modDirectory = await filesystem.getModDirectory(game.id, modToInstallDirectoryName);
    return await modDirectory.exists();
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
            final String id = modConfig['id'];
            final String title = modConfig['title'];
            final int category = modConfig['category'];
            final dynamic version = modConfig['version'];
            final YamlMap gameMap = modConfig['game'];
            final String? subtitle = modConfig['subtitle'];
            final YamlList? authorList = modConfig['author'];
            final bool installed = await isModInstalled(game, emulator.filesystem, modDirectory.path);
            final String path = modDirectory.path;
            modList.add(
              Mod(
                id: id,
                title: title,
                category: Category.values.singleWhere(
                  (element) => element.id == category,
                ),
                version: version,
                game: gameMap.value,
                subtitle: subtitle,
                installed: installed,
                author: authorList,
                path: path,
              ),
            );
          } catch (e) {
            debugPrint('Config file ${modConfigYaml.path} format not valid, skip: $e');
          }
        }
      }
    }

    return modList;
  }
}
