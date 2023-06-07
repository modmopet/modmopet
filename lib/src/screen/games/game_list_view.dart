import 'package:easy_localization/easy_localization.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/provider/emulator_provider.dart';
import 'package:modmopet/src/provider/game_list_provider.dart';
import 'package:modmopet/src/screen/emulator_picker/emulator_picker_view.dart';
import 'package:modmopet/src/screen/games/games_emulator_view.dart';
import 'package:modmopet/src/screen/mods/mods_view.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';
import 'package:modmopet/src/widgets/mm_evelated_button.dart';
import 'package:modmopet/src/widgets/mm_loading_indicator.dart';

/// Displays a list of the games installed at the emulator
class GameListView extends HookConsumerWidget {
  static const routeName = '/game_list';
  const GameListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emulator = ref.watch(emulatorProvider);
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
          child: emulator.when(
            data: (emulator) {
              if (emulator != null) {
                return buildGameListView(context, ref);
              }

              return emulatorNotFoundView(context, ref);
            },
            error: (error, _) => Text(error.toString()),
            loading: () => MMLoadingIndicator(),
          ),
        ),
      ],
    );
  }

  Widget buildGameListView(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gameListProvider);
    return games.when(
      loading: () => MMLoadingIndicator(),
      error: (err, stack) => Text(err.toString()),
      data: (games) {
        if (games.isNotEmpty == true) {
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
                onTap: () {
                  ref.watch(gameProvider.notifier).state = game;
                  Navigator.restorablePushNamed(
                    context,
                    ModsView.routeName,
                  );
                },
              );
            },
          );
        }

        return buildNoGamesFoundView(context, ref);
      },
    );
  }

  Widget emulatorNotFoundView(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: 600.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_off_outlined,
            size: 86.0,
            color: MMColors.instance.primary,
          ),
          Text(
            'emulator_not_found_title'.tr(),
            style: textTheme.bodyLarge?.copyWith(
              color: MMColors.instance.bodyText,
              fontSize: 21.0,
            ),
          ),
          Text(
            'emulator_not_found_text'.tr(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20.0,
          ),
          MMElevatedButton.primary(
            onPressed: () {
              ref.read(selectedEmulatorIdProvider.notifier).state = null;
              Navigator.pushReplacementNamed(
                context,
                EmulatorPickerView.routeName,
              );
            },
            child: Text('emulator_not_found_button'.tr()),
          ),
        ],
      ),
    );
  }

  Widget buildNoGamesFoundView(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: 600.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_outlined,
            size: 86.0,
            color: MMColors.instance.primary,
          ),
          Text(
            'no_games_found_title'.tr(),
            style: textTheme.bodyLarge?.copyWith(
              color: MMColors.instance.bodyText,
              fontSize: 21.0,
            ),
          ),
          Text(
            'no_games_found_text'.tr(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20.0,
          ),
          MMElevatedButton.primary(
            onPressed: () => ref.invalidate(gameListProvider),
            child: Text('no_games_found_button'.tr()),
          ),
        ],
      ),
    );
  }
}
