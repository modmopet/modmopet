import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/config.dart';
import 'package:modmopet/src/entity/game.dart';

// Holds the installed games as a List<Game>
final gameListProvider = FutureProvider<List<Game>>((ref) async {
  // For deveopment state just hard pick a game right now
  return [ModMopedConfig().games.first];
});
