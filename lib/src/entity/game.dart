import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:modmopet/src/entity/git_source.dart';
part 'game.freezed.dart';

@freezed
abstract class Game with _$Game {
  Game._();
  factory Game({
    required String id,
    required String title,
    required String version,
    required List<GitSource> sources,
    required String bannerUrl,
    required String iconUrl,
    required String publisher,
  }) = _Game;
}
