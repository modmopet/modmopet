import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/screen/games/game_list_provider.dart';
import 'package:modmopet/src/screen/mods/mod_list_provider.dart';
import 'package:modmopet/src/screen/mods/mod_list_view.dart';

/// Displays a list of the games installed at the emulator
class GameListView extends HookConsumerWidget {
  static const routeName = '/game_list';
  const GameListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gameListProvider);
    return Container(
      child: games.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text(err.toString()),
        data: (games) {
          return buildListView(games, ref);
        },
      ),
    );
  }

  Widget buildListView(List<Game> games, WidgetRef ref) {
    return ListView.builder(
      restorationId: 'modListView',
      itemCount: games.length,
      itemBuilder: (BuildContext context, int index) {
        final Game game = games[index];
        return ListTile(
          title: Text(game.title),
          shape: const BorderDirectional(
            bottom: BorderSide(width: 1.0),
          ),
          leading: const Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.color_lens,
                size: 25.0,
              ),
              SizedBox(width: 8.0),
              Icon(
                Icons.circle,
                color: Colors.white60,
                size: 10.0,
              ),
            ],
          ),
          onTap: () {
            // Set game
            ref.watch(gameProvider.notifier).state = game;
            Navigator.restorablePushNamed(
              context,
              ModListView.routeName,
            );
          },
          subtitle: Text(game.version),
          trailing: const Text('Placeholder'),
        );
      },
    );
  }
}
