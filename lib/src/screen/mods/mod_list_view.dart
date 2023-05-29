import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/config.dart';
import 'package:modmopet/src/provider/mod_list_provider.dart';
import 'package:modmopet/src/screen/games/game_list_view.dart';
import 'package:modmopet/src/screen/mods/mod_category_list_view.dart';
import 'package:modmopet/src/service/routine.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';
import 'package:modmopet/src/widgets/mm_breadcrumbs_bar.dart';
import 'package:modmopet/src/widgets/mm_loading_indicator.dart';
import '../../entity/mod.dart';

/// Displays a list of available mods for the game
class ModListView extends HookConsumerWidget {
  static const routeName = '/mod_list';
  const ModListView({super.key});

  Map<int, List<Mod>> splitModsInCategory(List<Mod> mods) {
    Map<int, List<Mod>> modListByCategories = {};
    for (int categoryId in MMConfig().supportedCategories.keys) {
      final modList = mods.takeWhile((Mod mod) => mod.category == categoryId).toList();
      modList.sort((a, b) => a.title.compareTo(b.title));
      final Map<int, List<Mod>> modListMap = {categoryId: modList};
      modListByCategories.addAll(modListMap);
    }

    return modListByCategories;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.read(gameProvider);
    final rawMods = ref.watch(modsProvider);

    // Use memoized function to call update routine only on first build
    useMemoized(() async {
      if (game != null) AppRoutineService.instance.checkForUpdates(game);
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
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    rawMods.when(
                      loading: () => MMLoadingIndicator(),
                      error: (err, stack) => Text(err.toString()),
                      data: (rawMods) {
                        final mods = splitModsInCategory(rawMods);
                        return createCategoryModLists(mods);
                      },
                    ),
                  ],
                ),
              ),
              const Text('no data.')
            ],
          ),
        ),
      ],
    );
  }

  Widget createCategoryModLists(Map<int, List<Mod>> modListMap) {
    List<ModCategoryListView> modCategoryListViews = [];
    for (var modList in modListMap.entries) {
      modCategoryListViews.add(ModCategoryListView(categoryId: modList.key, mods: modList.value));
    }

    return Column(
      children: modCategoryListViews,
    );
  }
}
