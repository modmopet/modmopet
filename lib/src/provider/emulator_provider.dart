import 'package:get_storage/get_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/entity/emulator.dart';
import 'package:modmopet/src/service/emulator.dart';

final selectedEmulatorIdProvider = StateProvider<String?>((ref) => GetStorage().read('emulatorId'));
final withCustomSelectProvider = StateProvider<bool>((ref) => false);

final emulatorProvider = FutureProvider<Emulator?>((ref) async {
  final String? selectedEmulatorId = ref.watch(selectedEmulatorIdProvider);
  final bool withCustomSelect = ref.watch(withCustomSelectProvider);

  GetStorage().write('emulatorId', selectedEmulatorId);
  return EmulatorService.instance.evaluateEmulator(selectedEmulatorId, withCustomSelect);
});
