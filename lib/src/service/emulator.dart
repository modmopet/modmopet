import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:modmopet/src/config.dart';
import 'package:modmopet/src/entity/emulator.dart';
import 'package:modmopet/src/provider/emulator_provider.dart';
import 'package:modmopet/src/service/filesystem/emulator/ryujinx_filesystem.dart';
import 'package:modmopet/src/service/filesystem/emulator/yuzu_filesystem.dart';
import 'package:modmopet/src/service/filesystem/emulator_filesystem.dart';
import 'package:modmopet/src/service/logger.dart';
import 'package:modmopet/src/service/storage.dart';
import 'package:path/path.dart' as path;

class EmulatorService {
  EmulatorService._();
  static final instance = EmulatorService._();

  Future<void> saveSelectedEmulator(String emulatorId) async {
    final prefs = await StorageService.instance.prefs;
    prefs.setString('selectedEmulator', emulatorId);
  }

  Future<void> clearSelectedEmulator() async {
    final prefs = await StorageService.instance.prefs;
    prefs.remove('selectedEmulator');
  }

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
        hasMetadataSupport: supportedEmulators[emulatorId]['hasMetadataSupport'],
        path: defaultPath,
      );
    } else if (emulatorFilesystem.runtimeType == RyujinxFilesystem) {
      final defaultPath = (await emulatorFilesystem.defaultEmulatorAppDirectory()).path;
      return Emulator(
        id: emulatorId,
        name: supportedEmulators[emulatorId]['name'],
        filesystem: supportedEmulators[emulatorId]['filesystem'],
        hasMetadataSupport: supportedEmulators[emulatorId]['hasMetadataSupport'],
        path: defaultPath,
      );
    }

    return null;
  }

  Future<Emulator?> evaluateEmulator(
    EmulatorRef ref,
    String? currentEmulatorId,
    bool withCustomSelect,
  ) async {
    if (currentEmulatorId != null) {
      // Create emulator object
      Emulator? emulator = await createEmulatorById(currentEmulatorId);
      if (emulator != null) {
        // Check if default emulator application folder path is valid or user wants to select manually
        if (!await EmulatorService.instance.isValidEmulatorPath(emulator) || withCustomSelect) {
          return updateEmulatorPathByUserSelection(emulator, ref);
        }

        return emulator;
      }
    }

    return null;
  }

  Future<Emulator?> updateEmulatorPathByUserSelection(Emulator emulator, EmulatorRef ref) async {
    // Try again by user selected path
    String? selectedPath = await FilePicker.platform.getDirectoryPath();
    if (selectedPath != null) {
      final updatedEmulator = emulator.copyWith(path: selectedPath);
      if (await EmulatorService.instance.isValidEmulatorPath(updatedEmulator)) {
        return updatedEmulator;
      }
    }

    // Clear selected emulator after no valid path to emulator found
    ref.read(selectedEmulatorProvider.notifier).clearEmulator();

    return null;
  }
}
