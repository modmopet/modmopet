import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/entity/emulator.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/provider/game_list_provider.dart';
import 'package:modmopet/src/screen/games/game_list_actionbar_widget.dart';
import 'package:modmopet/src/screen/games/game_list_empty_view.dart';
import 'package:modmopet/src/screen/games/game_list_meta_widget.dart';
import 'package:modmopet/src/screen/games/game_list_no_emulator_view.dart';
import 'package:modmopet/src/screen/games/games_emulator_view.dart';
import 'package:modmopet/src/screen/mods/mods_view.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';
import 'package:modmopet/src/widgets/mm_breadcrumbs_bar.dart';
import 'package:modmopet/src/widgets/mm_emulator_picker_dialog.dart';
import 'package:modmopet/src/widgets/mm_loading_indicator.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Displays a list of the games installed at the emulator
class GameListView extends HookConsumerWidget {
  static const routeName = '/game_list';
  const GameListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedEmulator = ref.watch(selectedEmulatorProvider).value;
    final emulator = ref.watch(emulatorProvider);
    final games = ref.watch(gameListProvider);

    // Game list is default view if no emulator was yet picked
    // This shows the dialog to let the user pick an emulator for the first time
    // todo: replace this with a real first setup journey
    if (selectedEmulator == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const MMEmulatorPickerDialog();
          },
        );
      });
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const MMBreadcrumbsBar('Games - Overview'),
        // EMULATOR VIEW
        const SizedBox(
          height: 140.0,
          width: double.maxFinite,
          child: GamesEmulatorView(),
        ),
        // ACTION BAR VIEW
        const GameListActionBarWidget(),
        Expanded(
          child: games.when(
            loading: () => MMLoadingIndicator(),
            error: ((error, stackTrace) {
              Sentry.captureException(error, stackTrace: stackTrace);
              return Text(error.toString());
            }),
            data: (games) {
              if (emulator.value != null) {
                return buildGameListView(games, emulator.value!, context, ref);
              }

              return const GameListNoEmulatorView();
            },
          ),
        ),
      ],
    );
  }

  Widget buildGameListView(List<Game> games, Emulator emulator, BuildContext context, WidgetRef ref) {
    if (games.isNotEmpty == true) {
      return ListView.builder(
        restorationId: 'modListView',
        itemCount: games.length,
        itemBuilder: (BuildContext context, int index) {
          final Game game = games[index];
          return Material(
            type: MaterialType.transparency,
            child: ListTile(
              title: Text(game.title),
              minVerticalPadding: 15.0,
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
              subtitle: Text('by ${game.publisher}', style: Theme.of(context).textTheme.bodySmall),
              trailing: Container(
                width: 175.0,
                padding: const EdgeInsets.only(left: 10.0),
                decoration: emulator.hasMetadataSupport == true
                    ? BoxDecoration(
                        border: Border(left: BorderSide(width: 1, color: MMColors.instance.backgroundBorder)),
                      )
                    : null,
                child: emulator.hasMetadataSupport && game.meta != null ? GameListMetaWidget(game: game) : Container(),
              ),
              onTap: () {
                ref.watch(gameProvider.notifier).state = game;
                Navigator.restorablePushNamed(
                  context,
                  ModsView.routeName,
                );
              },
            ),
          );
        },
      );
    }
    return const GameListEmptyView();
  }
}
