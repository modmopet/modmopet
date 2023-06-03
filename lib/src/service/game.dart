import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:modmopet/src/service/filesystem/platform_filesystem.dart';
import 'package:modmopet/src/service/logger.dart';

class GameService {
  GameService._();
  static final instance = GameService._();

  Future<void> checkTitlesDatabase() async {
    File titlesJsonFile = await PlatformFilesystem.instance.getFile('titles.json');
    if (!await titlesJsonFile.exists()) {
      final response = await Dio().download(
          'https://github.com/arch-box/titledb/releases/download/latest/titles.US.en.json', titlesJsonFile.path);

      if (response.statusCode == 200) {
        LoggerService.instance.log('Check title database: Download successfull...');
      } else {
        LoggerService.instance.log('Failed to download titles database with code: ${response.statusCode}');
      }
    }
  }

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
