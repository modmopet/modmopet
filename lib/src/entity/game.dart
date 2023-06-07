import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:modmopet/src/entity/game_meta.dart';
import 'package:modmopet/src/entity/git_source.dart';
part 'game.freezed.dart';

@freezed
class Game with _$Game {
  Game._();
  factory Game({
    required String id,
    required String title,
    required String version,
    required List<GitSource> sources,
    required String bannerUrl,
    required String iconUrl,
    required String publisher,
    required GameMeta meta,
  }) = _Game;
}

final gameProvider = StateProvider<Game?>((ref) => null);

final selectedGameVersionProvider = StateProvider<String?>((ref) => null);
