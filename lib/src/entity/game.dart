import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:modmopet/src/entity/git_source.dart';
part 'game.freezed.dart';

@freezed
class Game with _$Game {
  const factory Game({
    required String id,
    required String title,
    required String version,
    required List<GitSource> sources,
    String? bannerUrl,
  }) = _Game;
}
