import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:modmopet/src/config.dart';
import 'package:modmopet/src/entity/emulator.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/entity/git_source.dart';
import 'package:modmopet/src/service/filesystem/emulator_filesystem.dart';
import 'package:modmopet/src/service/filesystem/platform_filesystem.dart';
import 'package:modmopet/src/service/game.dart';
import 'package:modmopet/src/service/github/github.dart';
import 'package:modmopet/src/service/loading.dart';
import 'package:modmopet/src/service/logger.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// Holds the installed games as a List<Game>
final gameListProvider = FutureProvider.autoDispose<List<Game>>((ref) async {
  List<Game> games = List.empty(growable: true);
  final Emulator? emulator = await ref.watch(emulatorProvider.future);
  final EmulatorFilesystemInterface? emulatorFilesystem = emulator?.filesystem;
  final gameFileList = await emulatorFilesystem?.getGamesDirectoryList(emulator!);

  await LoadingService.instance.show('Check title db for updates...');
  await _checkTitlesDatabase();

  if (gameFileList != null) {
    Map<String, dynamic>? titlesList = await GameService.instance.buildTitlesMap();
    if (titlesList != null) {
      await for (FileSystemEntity element in gameFileList) {
        final titleId = path.basenameWithoutExtension(element.path).split('.').first.toUpperCase();
        if (titlesList.containsKey(titleId)) {
          final dynamic gameMetadata = await emulatorFilesystem?.getGameMetadata(emulator!, titleId);
          Map<String, List<GitSource>> sources = MMConfig().defaultSupportedSources;
          final mappedSources = sources.map((key, value) => MapEntry(key.toUpperCase(), value));
          await LoggerService.instance.log('Found title: $titleId');
          if (_titleIsValid(titlesList[titleId])) {
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
    }
  }

  await LoadingService.instance.clear();

  return games;
});

Future<void> _downloadTitleDbFile(ReleaseAsset asset, File titlesJsonFile) async {
  try {
    await Dio().download(asset.browserDownloadUrl!, titlesJsonFile.path, onReceiveProgress: (count, total) async {
      await LoadingService.instance.show(
        'Dowload new title db: ${(count / 1000000).toStringAsFixed(2)}MB/${(total / 1000000).toStringAsFixed(2)}MB',
      );
    });
  } catch (e, st) {
    debugPrint(e.toString());
    Sentry.captureException(e, stackTrace: st);

    // Get sure to delete file if download breaks for some reason
    if (await titlesJsonFile.exists()) {
      await titlesJsonFile.delete();
    }
  }
}

bool _titleIsValid(Map<String, dynamic> titleData) {
  List<String> keysToCheck = ['name', 'bannerUrl', 'iconUrl', 'publisher'];

  bool isValid = true;
  for (var key in keysToCheck) {
    var value = titleData[key];
    if (value == null) {
      isValid = false;
      break;
    }
  }

  return isValid;
}

Future<void> _checkTitlesDatabase() async {
  await Future.delayed(const Duration(seconds: 1));
  File titlesJsonFile = await PlatformFilesystem.instance.getFile('titlesdb.json');
  final slug = RepositorySlug('arch-box', 'titledb');
  final latestRelease = await GithubClient().getLatestTitleDBRelease(slug);

  if (latestRelease.assets != null) {
    final ReleaseAsset? asset = latestRelease.assets?.singleWhere((element) => element.name == 'titles.US.en.json');
    if (asset != null) {
      // If file exists, check if its up to date, if not update and replace
      if (await titlesJsonFile.exists()) {
        if ((await titlesJsonFile.stat()).changed.compareTo(asset.createdAt!) < 0) {
          LoadingService.instance.show("Downloading new TitleDB. Please wait...");
          await _downloadTitleDbFile(asset, titlesJsonFile);
          return;
        }

        LoggerService.instance.log("GameService: TitleDB is up-to-date.");
        return;
      }

      // File does not exists, download.
      await _downloadTitleDbFile(asset, titlesJsonFile);
    }

    Sentry.captureMessage('TitlesDB file does not exists or is not available!', level: SentryLevel.fatal);
  }
}
