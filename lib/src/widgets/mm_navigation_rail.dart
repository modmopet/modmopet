import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/screen/games/game_list_view.dart';
import 'package:modmopet/src/screen/settings/settings_view.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class MMNavigationRail extends HookConsumerWidget {
  final double destinationPadding;
  const MMNavigationRail({
    this.destinationPadding = 10.0,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Navigation index
    final navigationIndex = ref.watch(navigationIndexProvider.notifier);

    return NavigationRail(
      labelType: NavigationRailLabelType.all,
      backgroundColor: Colors.transparent,
      indicatorColor: MMColors.instance.primary,
      selectedIndex: navigationIndex.state,
      onDestinationSelected: (index) {
        navigationIndex.update((state) => index);
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, GameListView.routeName);
            break;
          case 1:
            Navigator.pushReplacementNamed(context, SettingsView.routeName);
          default:
        }
        if (index == 0) {
          Navigator.pushNamed(context, GameListView.routeName);
        }
        if (index == 1) {
          Navigator.pushNamed(context, SettingsView.routeName);
        }
      },
      destinations: [
        const NavigationRailDestination(
          padding: EdgeInsets.only(top: 33.0),
          icon: Icon(Icons.view_list),
          label: Text('Games'),
        ),
        NavigationRailDestination(
          padding: EdgeInsets.symmetric(vertical: destinationPadding),
          icon: const Icon(Icons.settings),
          label: const Text('Settings'),
        ),
      ],
      selectedIconTheme: IconThemeData(color: MMColors.instance.lightWhite),
      unselectedIconTheme: const IconThemeData(color: Colors.white24),
      selectedLabelTextStyle: TextStyle(color: MMColors.instance.lightWhite),
      unselectedLabelTextStyle: const TextStyle(color: Colors.white24),
    );
  }
}
