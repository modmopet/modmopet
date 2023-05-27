import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/config.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/entity/git_source.dart';
import 'package:modmopet/src/provider/emulator_provider.dart';
import 'package:modmopet/src/provider/mod_list_provider.dart';
import 'package:modmopet/src/service/filesystem/emulator_filesystem_interface.dart';
import 'package:modmopet/src/service/game.dart';
import 'package:path/path.dart' as path;

// Holds the installed games as a List<Game>
final gameListProvider = FutureProvider<List<Game>?>((ref) async {
  List<Game> games = List.empty(growable: true);
  final emulator = ref.watch(emulatorProvider);
  final EmulatorFilesystemInterface? emulatorFilesystem = emulator.value?.filesystem;
  final gameFileList = await emulatorFilesystem?.gameFileList();

  if (gameFileList != null) {
    Map<String, dynamic> titlesList = await GameService.instance.buildTitleMap();
    await for (FileSystemEntity element in gameFileList) {
      final titleId = path.basenameWithoutExtension(element.path);
      if (titlesList.containsKey(titleId.toUpperCase())) {
        Map<String, List<GitSource>> sources = MMConfig().supportedSources;
        if (sources.containsKey(titleId.toUpperCase())) {
          debugPrint('Found title: $titleId');
          final titleEntry = titlesList[titleId.toUpperCase()];
          final game = Game(
            id: titleId,
            title: titleEntry['name'],
            version: 'unkown',
            sources: sources[titleId.toUpperCase()]!,
            bannerUrl: titleEntry['bannerUrl'],
            iconUrl: titleEntry['iconUrl'],
          );
          games.add(game);
          ref.read(sourceProvider.notifier).update((state) => sources[titleId.toUpperCase()]!.first);
        }
      }
    }
  }

  return games;
});
