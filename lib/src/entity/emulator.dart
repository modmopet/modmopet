import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:modmopet/src/service/emulator.dart';
import 'package:modmopet/src/service/filesystem/emulator_filesystem.dart';
import 'package:modmopet/src/service/storage/shared_preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'emulator.freezed.dart';
part 'emulator.g.dart';

@freezed
class Emulator with _$Emulator {
  Emulator._();
  factory Emulator({
    required String id,
    required String name,
    required EmulatorFilesystemInterface filesystem,
    required bool hasMetadataSupport,
    required String path,
  }) = _Emulator;
}

@riverpod
class SelectedEmulator extends _$SelectedEmulator {
  final storage = SharedPreferencesStorage.instance;

  Future<String?> _getSelectedEmulator() async {
    return await storage.get<String>('selectedEmulator');
  }

  @override
  FutureOr<String?> build() async => _getSelectedEmulator();

  Future<void> set(String selectedEmulator) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await storage.set<String>('selectedEmulator', selectedEmulator);
      return await _getSelectedEmulator();
    });
  }

  Future<void> clear() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await storage.remove('selectedEmulator');
      return await _getSelectedEmulator();
    });
  }
}

final withCustomSelectProvider = StateProvider<bool>((ref) => false);

@riverpod
Future<Emulator?> emulator(EmulatorRef ref) async {
  final selectedEmulator = await ref.watch(selectedEmulatorProvider.future);
  final withCustomSelect = ref.watch(withCustomSelectProvider);

  return await EmulatorService.instance.evaluateEmulator(ref, selectedEmulator, withCustomSelect);
}
