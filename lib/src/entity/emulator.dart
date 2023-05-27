import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:modmopet/src/service/filesystem/emulator_filesystem_interface.dart';
part 'emulator.freezed.dart';

@freezed
class Emulator with _$Emulator {
  const factory Emulator({
    required int id,
    required String name,
    required EmulatorFilesystemInterface filesystem,
  }) = _Emulator;
}
