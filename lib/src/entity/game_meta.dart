import 'package:freezed_annotation/freezed_annotation.dart';
part 'game_meta.freezed.dart';

@freezed
class GameMeta with _$GameMeta {
  GameMeta._();
  factory GameMeta({
    required String title,
    required bool favorite,
    required int playTime,
    required DateTime? lastPlayed,
  }) = _GameMeta;
}
