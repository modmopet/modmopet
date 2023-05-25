import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/config.dart';

class MMNavigationRail extends HookConsumerWidget {
  final double destinationPadding;
  const MMNavigationRail({
    this.destinationPadding = 5.0,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Navigation index
    final navigationRailIndex = useState(0);
    return NavigationRail(
      labelType: NavigationRailLabelType.all,
      backgroundColor: Colors.transparent,
      indicatorColor: Colors.purple,
      leading: const Column(
        children: [
          Text(MMConfig.title),
          Text(MMConfig.version),
        ],
      ),
      selectedIndex: navigationRailIndex.value,
      onDestinationSelected: (index) {
        navigationRailIndex.value = index;
      },
      destinations: [
        NavigationRailDestination(
          padding: EdgeInsets.only(top: 20.0, bottom: destinationPadding),
          icon: const Icon(Icons.view_list),
          label: const Text('Games'),
        ),
        NavigationRailDestination(
          padding: EdgeInsets.symmetric(vertical: destinationPadding),
          icon: const Icon(Icons.settings),
          label: const Text('Settings'),
        ),
        NavigationRailDestination(
          padding: EdgeInsets.symmetric(vertical: destinationPadding),
          icon: const Icon(Icons.settings),
          label: const Text('Settings'),
        ),
        NavigationRailDestination(
          padding: EdgeInsets.symmetric(vertical: destinationPadding),
          icon: const Icon(Icons.settings),
          label: const Text('Settings'),
        ),
      ],
      selectedIconTheme: const IconThemeData(color: Colors.white70),
      unselectedIconTheme: const IconThemeData(color: Colors.white24),
      selectedLabelTextStyle: const TextStyle(color: Colors.white70),
      unselectedLabelTextStyle: const TextStyle(color: Colors.white24),
    );
  }
}
