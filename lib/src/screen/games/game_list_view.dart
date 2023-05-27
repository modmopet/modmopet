import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/entity/emulator.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/provider/emulator_provider.dart';
import 'package:modmopet/src/provider/game_list_provider.dart';
import 'package:modmopet/src/provider/mod_list_provider.dart';
import 'package:modmopet/src/screen/mods/mod_list_view.dart';

/// Displays a list of the games installed at the emulator
class GameListView extends HookConsumerWidget {
  static const routeName = '/game_list';
  const GameListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emulator = ref.watch(emulatorProvider);
    final games = ref.watch(gameListProvider);

    return emulator.value is Emulator
        ? Container(
            child: games.when(
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text(err.toString()),
              data: (games) {
                return games == null ? Container() : buildListView(games, ref);
              },
            ),
          )
        : const Text('Could not find emulator.');
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
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FastCachedImage(
                url: game.iconUrl,
                cacheHeight: 50,
                cacheWidth: 50,
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
