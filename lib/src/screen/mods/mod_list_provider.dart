import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/config.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/entity/git_source.dart';
import 'package:modmopet/src/entity/mod.dart';
import 'package:modmopet/src/repository/mods.dart';

final gameProvider = StateProvider<Game>((ref) => MMConfig().games.first);
final sourceProvider = StateProvider<GitSource>((ref) {
  return MMConfig().games.first.sources.first;
});

final modsProvider = FutureProvider<List<Mod>>((ref) async {
  final game = ref.watch(gameProvider);
  final source = ref.watch(sourceProvider);
  return await ModsRepository().getAvailableMods(game, source);
});

final bannerImageProvider = StateProvider<Image?>((ref) {
  try {
    final image = Image.network(ref.watch(gameProvider).bannerUrl!);
    return image;
  } catch (e) {
    debugPrint('Not able to fetch banner image.');
  }
  return null;
});
