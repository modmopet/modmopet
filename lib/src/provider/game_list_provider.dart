import 'dart:io';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/config.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/entity/git_source.dart';
import 'package:modmopet/src/provider/emulator_provider.dart';
import 'package:modmopet/src/service/filesystem/emulator_filesystem.dart';
import 'package:modmopet/src/service/game.dart';
import 'package:modmopet/src/service/logger.dart';
import 'package:path/path.dart' as path;

// Holds the installed games as a List<Game>
final gameListProvider = FutureProvider<List<Game>>((ref) async {
  List<Game> games = List.empty(growable: true);
  final emulator = ref.watch(emulatorProvider).value;
  final EmulatorFilesystemInterface? emulatorFilesystem = emulator?.filesystem;
  final gameFileList = await emulatorFilesystem?.getGamesDirectoryList(emulator!);

  // Check if titles database needs to be downloaded first
  await GameService.instance.checkTitlesDatabase();

  if (gameFileList != null) {
    Map<String, dynamic> titlesList = await GameService.instance.buildTitleMap();
    await for (FileSystemEntity element in gameFileList) {
      final titleId = path.basenameWithoutExtension(element.path).split('.').first.toUpperCase();
      if (titlesList.containsKey(titleId)) {
        final dynamic gameMetadata = await emulatorFilesystem?.getGameMetadata(emulator!, titleId);
        Map<String, List<GitSource>> sources = MMConfig().defaultSupportedSources;
        final mappedSources = sources.map((key, value) => MapEntry(key.toUpperCase(), value));
        await LoggerService.instance.log('Found title: $titleId');
        final titleEntry = titlesList[titleId];
        final game = Game(
          id: titleId,
          title: titleEntry['name'],
          version: 'unkown',
          sources: mappedSources.isNotEmpty && mappedSources.containsKey(titleId)
              ? mappedSources[titleId.toUpperCase()]!
              : [],
          bannerUrl: titleEntry['bannerUrl'],
          iconUrl: titleEntry['iconUrl'],
          publisher: titleEntry['publisher'],
          meta: gameMetadata,
        );
        games.add(game);
      }
    }
  }

  return games;
});
