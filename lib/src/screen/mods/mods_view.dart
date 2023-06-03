import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/screen/games/game_list_view.dart';
import 'package:modmopet/src/screen/mods/mods_list_view.dart';
import 'package:modmopet/src/service/source.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';
import 'package:modmopet/src/widgets/mm_breadcrumbs_bar.dart';

/// Displays a list of available mods for the game
class ModsView extends HookConsumerWidget {
  static const routeName = '/mod_list';
  const ModsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);

    // Use memoized function to call update routine only on first widget build
    useMemoized(() async {
      if (game != null) {
        await SourceService.instance.checkForUpdates(game, ref);
      }
    });

    TabController tabController = useTabController(initialLength: 2);

    return Column(
      children: [
        MMBreadcrumbsBar('Games - ${game?.title} - Modifications', GameListView.routeName),
        Container(
          height: 200.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FastCachedImageProvider(game!.bannerUrl),
              alignment: Alignment.topLeft,
              fit: BoxFit.cover,
              opacity: 0.6,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  height: 45,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.title,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(game.version),
                    ],
                  ),
                ),
              ),
              TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                controller: tabController,
                indicatorColor: MMColors.instance.primary,
                indicatorWeight: 3,
                tabs: const [
                  Tab(
                    text: 'Installed',
                    icon: Icon(Icons.games_sharp, color: Colors.white),
                  ),
                  Tab(
                    text: 'Available',
                    icon: Icon(Icons.gamepad, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: const [
              SingleChildScrollView(
                physics: ScrollPhysics(),
                child: ModsListView(),
              ),
              Text('no data.')
            ],
          ),
        ),
      ],
    );
  }
}
