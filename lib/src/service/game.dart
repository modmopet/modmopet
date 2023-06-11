import 'dart:convert';
import 'dart:io';
import 'package:modmopet/src/service/filesystem/platform_filesystem.dart';
import 'package:modmopet/src/service/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class GameService {
  GameService._();
  static final instance = GameService._();

  Future<Map<String, dynamic>?> buildTitlesMap() async {
    File titlesJsonFile = await PlatformFilesystem.instance.getFile('titlesdb.json');
    if (await titlesJsonFile.exists()) {
      await LoggerService.instance.log('Game Service: Titles database found.');
      String? jsonContent = await titlesJsonFile.readAsString();
      try {
        final titlesJson = await jsonDecode(jsonContent);
        return titlesJson;
      } catch (error, strackTrace) {
        if (titlesJsonFile.existsSync()) {
          titlesJsonFile.delete();
        }
        Sentry.captureException(error, stackTrace: strackTrace);
      }
    }

    return null;
  }
}
