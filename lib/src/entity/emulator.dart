import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:modmopet/src/service/filesystem/emulator_filesystem.dart';
part 'emulator.freezed.dart';

@freezed
class Emulator with _$Emulator {
  Emulator._();
  factory Emulator({
    required String id,
    required String name,
    required EmulatorFilesystemInterface filesystem,
    String? path,
  }) = _Emulator;
}
