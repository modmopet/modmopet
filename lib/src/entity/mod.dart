import 'package:freezed_annotation/freezed_annotation.dart';
part 'mod.freezed.dart';

@freezed
class Mod with _$Mod {
  const Mod._();
  const factory Mod({
    required final String id,
    required final String title,
    required final int category,
    required final String version,
    required final Map<dynamic, dynamic> game,
    String? subtitle,
    String? description,
    Map<dynamic, dynamic>? author,
  }) = _Mod;
}

enum ModType {
  general,
  graphic,
  performance,
  teak,
}
