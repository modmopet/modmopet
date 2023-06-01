import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/entity/git_source.dart';
import 'package:modmopet/src/provider/game_list_provider.dart';
import 'package:modmopet/src/screen/games/games_emulator_view.dart';
import 'package:modmopet/src/screen/mods/mods_view.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';
import 'package:modmopet/src/widgets/mm_loading_indicator.dart';

/// Displays a list of the games installed at the emulator
class GameListView extends HookConsumerWidget {
  static const routeName = '/game_list';
  const GameListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gameListProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 150.0,
          width: double.maxFinite,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: MMColors.instance.primary, width: 3),
            ),
          ),
          child: const GamesEmulatorView(),
        ),
        Expanded(
          child: games.when(
            loading: () => MMLoadingIndicator(),
            error: (err, stack) => Text(err.toString()),
            data: (games) {
              return buildListView(games, ref);
            },
          ),
        ),
      ],
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
            debugPrint('Set game to: ${game.id}');
            ref.read(gameProvider.notifier).state = game;
            ref.read(sourceProvider.notifier).state = game.sources.first;
            Navigator.restorablePushNamed(
              context,
              ModsView.routeName,
            );
          },
          subtitle: Row(
            children: [
              Text('Version: ${game.version}'),
            ],
          ),
          trailing: const Text('Placeholder'),
        );
      },
    );
  }
}
