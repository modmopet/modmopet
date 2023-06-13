import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:modmopet/src/config.dart';
import 'package:modmopet/src/entity/emulator.dart';
import 'package:modmopet/src/service/filesystem/emulator/ryujinx_filesystem.dart';
import 'package:modmopet/src/service/filesystem/emulator/yuzu_filesystem.dart';
import 'package:modmopet/src/service/filesystem/emulator_filesystem.dart';
import 'package:modmopet/src/service/storage/shared_preferences_storage.dart';
import 'package:path/path.dart' as path;

class EmulatorService {
  EmulatorService._();
  static final instance = EmulatorService._();
  final storage = SharedPreferencesStorage.instance;

  Future<bool> isValidEmulatorPath(String emulatorId, String emulatorPath) async {
    final emulatorAppDirectory = Directory(emulatorPath);
    if (emulatorAppDirectory.existsSync()) {
      final identifierFound = emulatorAppDirectory.listSync().where((element) {
        final EmulatorFilesystem filesystem = MMConfig.supportedEmulators[emulatorId]['filesystem'];
        return path.basename(element.path) == filesystem.getIdentifier();
      });

      return identifierFound.isNotEmpty;
    }

    return false;
  }

  Future<Emulator?> createEmulatorById(String emulatorId) async {
    final supportedEmulators = MMConfig.supportedEmulators;

    if (emulatorId == 'yuzu') {
      final String? pathFromStorage = await storage.get<String?>('yuzuPath');
      final YuzuFilesystem emulatorFilesystem = MMConfig.supportedEmulators[emulatorId]['filesystem'];
      final defaultPath = await emulatorFilesystem.defaultEmulatorAppDirectory();

      return Emulator(
        id: emulatorId,
        name: supportedEmulators[emulatorId]['name'],
        filesystem: supportedEmulators[emulatorId]['filesystem'],
        hasMetadataSupport: supportedEmulators[emulatorId]['hasMetadataSupport'],
        path: pathFromStorage ?? defaultPath.path,
      );
    } else if (emulatorId == 'ryujinx') {
      final String? pathFromStorage = await storage.get<String?>('ryujinxPath');
      final RyujinxFilesystem emulatorFilesystem = MMConfig.supportedEmulators[emulatorId]['filesystem'];
      final defaultPath = await emulatorFilesystem.defaultEmulatorAppDirectory();
      return Emulator(
        id: emulatorId,
        name: supportedEmulators[emulatorId]['name'],
        filesystem: supportedEmulators[emulatorId]['filesystem'],
        hasMetadataSupport: supportedEmulators[emulatorId]['hasMetadataSupport'],
        path: pathFromStorage ?? defaultPath.path,
      );
    }

    return null;
  }

  Future<Emulator?> evaluateEmulator(
    EmulatorRef ref,
    String? selectedEmulator,
    bool withCustomSelect,
  ) async {
    if (selectedEmulator != null) {
      // Create emulator object
      final emulator = await createEmulatorById(selectedEmulator);
      if (emulator != null) {
        // Check if default emulator application folder path is valid
        final bool isValid = await EmulatorService.instance.isValidEmulatorPath(emulator.id, emulator.path);
        if (isValid == false || withCustomSelect == true) {
          await updateEmulatorPathByUserSelection(emulator, ref);
        }

        return emulator;
      }
    }

    return null;
  }

  Future<void> updateEmulatorPathByUserSelection(Emulator emulator, EmulatorRef ref) async {
    // Try again by user selected path
    String? selectedPath = await FilePicker.platform.getDirectoryPath();
    if (selectedPath != null) {
      if (await EmulatorService.instance.isValidEmulatorPath(emulator.id, selectedPath)) {
        // Save path to storage
        storage.set<String>('${emulator.id}Path', selectedPath);
        return;
      }
    }

    // Clear selected emulator after no valid path to emulator found
    ref.read(selectedEmulatorProvider.notifier).clear();
  }
}
