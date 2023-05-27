import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/entity/emulator.dart';
import 'package:modmopet/src/service/filesystem/emulator/ryujinx_filesystem.dart';
import 'package:modmopet/src/service/filesystem/emulator/yuzu_filesystem.dart';
import 'package:modmopet/src/service/logger.dart';
import 'package:path/path.dart' as path;

Future<Emulator?> _identifyEmulator(String emulatorDirectoryPath) async {
  final Directory emulatorDirectory = Directory(emulatorDirectoryPath);
  await for (var element in emulatorDirectory.list()) {
    if (element is Directory) {
      final directory = path.basename(element.path);
      if (directory == YuzuFilesystem.identifierDirectory) {
        LoggerService.instance.log('Yuzu foulder found.');
        return Emulator(id: 1, name: 'Yuzu', filesystem: YuzuFilesystem.instance);
      }

      if (directory == RyujinxFilesystem.identifierDirectory) {
        LoggerService.instance.log('Ryujinx folder found.');
        return Emulator(id: 2, name: 'Ryujinx', filesystem: RyujinxFilesystem.instance);
      }
    }
  }

  return null;
}

final emulatorProvider = FutureProvider<Emulator?>((ref) async {
  String? emulatorDirectoryPath = await FilePicker.platform.getDirectoryPath(
    dialogTitle: 'Please choose emulator directory',
    initialDirectory: null,
  );

  if (emulatorDirectoryPath != null) {
    return _identifyEmulator(emulatorDirectoryPath);
  }

  return null;
});
