import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/entity/git_source.dart';
import 'package:modmopet/src/entity/mod.dart';
import 'package:modmopet/src/service/filesystem/platform_filesystem.dart';
import 'package:yaml/yaml.dart';

class ModsRepository {
  Future<List<Mod>> getAvailableMods(Game game, GitSource source) async {
    final List<Mod> modList = List.empty(growable: true);
    Directory gameModsDirectory = await PlatformFilesystem.instance.gameModsDirectory(game, source);
    if (await gameModsDirectory.exists()) {
      final Stream<FileSystemEntity> modDirectories = gameModsDirectory.list(recursive: true);
      for (var modDirectory in await modDirectories.toList()) {
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
            final YamlMap? authorMap = modConfig['author'];

            modList.add(
              Mod(
                id: id,
                title: title,
                category: category,
                version: version,
                game: gameMap.value,
                subtitle: subtitle,
                author: authorMap?.value,
              ),
            );
          } catch (e) {
            debugPrint('Config file format not valid, skip: $e');
          }
        }
      }
    }

    return modList;
  }
}
