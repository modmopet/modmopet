import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/provider/game_list_provider.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';
import 'package:modmopet/src/widgets/mm_evelated_button.dart';

class GameListEmptyView extends ConsumerWidget {
  const GameListEmptyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: MMElevatedButton.primary(
                  onPressed: () => ref.invalidate(gameListProvider),
                  child: Text('no_games_found_button'.tr()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: MMElevatedButton.secondary(
                  onPressed: () => ref.invalidate(gameListProvider),
                  child: Text('no_games_found_button_update'.tr()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
