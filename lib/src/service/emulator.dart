import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:modmopet/src/config.dart';
import 'package:modmopet/src/entity/emulator.dart';
import 'package:modmopet/src/service/filesystem/emulator/ryujinx_filesystem.dart';
import 'package:modmopet/src/service/filesystem/emulator/yuzu_filesystem.dart';
import 'package:modmopet/src/service/filesystem/emulator_filesystem.dart';
import 'package:modmopet/src/service/logger.dart';
import 'package:path/path.dart' as path;

class EmulatorService {
  EmulatorService._();
  static final instance = EmulatorService._();

  Future<bool> isValidEmulatorPath(Emulator emulator) async {
    final Directory emulatorAppDirectory = Directory(emulator.path!);
    if (emulatorAppDirectory.existsSync()) {
      await for (var element in emulatorAppDirectory.list()) {
        if (element is Directory) {
          final directory = path.basename(element.path);
          if (directory == emulator.filesystem.getIdentifier()) {
            LoggerService.instance.log('Emulator folder found.');
            return true;
          }
        }
      }
    }

    return false;
  }

  Future<Emulator?> createEmulatorById(String emulatorId) async {
    final supportedEmulators = MMConfig().supportedEmulators;
    final EmulatorFilesystem emulatorFilesystem = MMConfig().supportedEmulators[emulatorId]['filesystem'];

    if (emulatorFilesystem.runtimeType == YuzuFilesystem) {
      final defaultPath = (await emulatorFilesystem.defaultEmulatorAppDirectory()).path;
      return Emulator(
        id: emulatorId,
        name: supportedEmulators[emulatorId]['name'],
        filesystem: supportedEmulators[emulatorId]['filesystem'],
        path: defaultPath,
      );
    } else if (emulatorFilesystem.runtimeType == RyujinxFilesystem) {
      final defaultPath = (await emulatorFilesystem.defaultEmulatorAppDirectory()).path;
      return Emulator(
        id: emulatorId,
        name: supportedEmulators[emulatorId]['name'],
        filesystem: supportedEmulators[emulatorId]['filesystem'],
        path: defaultPath,
      );
    }

    return null;
  }

  Future<Emulator?> evaluateEmulator(String? currentEmulatorId) async {
    if (currentEmulatorId != null) {
      // Create emulator object
      Emulator? emulator = await createEmulatorById(currentEmulatorId);
      if (emulator != null) {
        // Check if default emulator application folder path is valid
        if (!await EmulatorService.instance.isValidEmulatorPath(emulator)) {
          // Try again by user selected path
          String? selectedPath = await FilePicker.platform.getDirectoryPath();
          if (selectedPath != null) {
            final updatedEmulator = emulator.copyWith(path: selectedPath);
            if (await EmulatorService.instance.isValidEmulatorPath(updatedEmulator)) {
              return updatedEmulator;
            }
          }
        } else {
          return emulator;
        }
      }
    }

    return null;
  }
}
