import 'dart:convert';
import 'dart:io';
import 'package:modmopet/src/service/filesystem/platform_filesystem.dart';
import 'package:modmopet/src/service/logger.dart';

class GameService {
  GameService._();
  static final instance = GameService._();

  Future<dynamic> buildTitleMap() async {
    File titlesJsonFile = await PlatformFilesystem.instance.getFile('titles.US.en.json');
    if (await titlesJsonFile.exists()) {
      LoggerService.instance.log('Game Service: Titles database found.');
      String? jsonContent = await titlesJsonFile.readAsString();
      final titlesJson = await jsonDecode(jsonContent);

      return titlesJson;
    }

    return null;
  }
}
