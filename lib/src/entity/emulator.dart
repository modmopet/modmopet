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
    String? path,
  }) = _Emulator;
}

@riverpod
class SelectedEmulator extends _$SelectedEmulator {
  final storage = SharedPreferencesStorage.instance;

  Future<String?> _getSelectedEmulator() async {
    return storage.get<String>('selectedEmulator');
  }

  @override
  FutureOr<String?> build() async => _getSelectedEmulator();

  Future<void> setEmulator(String selectedEmulator) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      storage.set<String>('selectedEmulator', selectedEmulator);
      return _getSelectedEmulator();
    });
  }

  Future<void> clearEmulator() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      storage.remove('selectedEmulator');
      return _getSelectedEmulator();
    });
  }
}

final withCustomSelectProvider = StateProvider<bool>((ref) => false);

@riverpod
Future<Emulator?> emulator(EmulatorRef ref) async {
  final selectedEmulatorId = ref.watch(selectedEmulatorProvider);
  final bool withCustomSelect = ref.watch(withCustomSelectProvider);
  return await EmulatorService.instance.evaluateEmulator(ref, selectedEmulatorId.value, withCustomSelect);
}
