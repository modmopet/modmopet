import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:modmopet/src/service/filesystem/platform_filesystem.dart';

class GameService {
  GameService._();
  static final instance = GameService._();

  Future<dynamic> buildTitleMap() async {
    File titlesJsonFile = await PlatformFilesystem.instance.getFile('titles.US.en.json');
    if (await titlesJsonFile.exists()) {
      debugPrint('Titles found.');
      String? jsonContent = await titlesJsonFile.readAsString();
      final titlesJson = await jsonDecode(jsonContent);

      return titlesJson;
    }

    return null;
  }
}
