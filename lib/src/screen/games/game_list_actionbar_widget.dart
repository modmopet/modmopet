import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/provider/game_list_provider.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';

class GameListActionBarWidget extends ConsumerWidget {
  const GameListActionBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 45,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            width: 1,
            color: MMColors.instance.backgroundBorder,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          createActionMenu(context, ref),
        ],
      ),
    );
  }

  Widget createActionMenu(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        IconButton(
          tooltip: 'Reload',
          onPressed: () {
            ref.invalidate(gameListProvider);
          },
          color: MMColors.instance.primary,
          icon: const Icon(
            Icons.refresh_outlined,
            size: 24.0,
          ),
        ),
      ],
    );
  }
}
