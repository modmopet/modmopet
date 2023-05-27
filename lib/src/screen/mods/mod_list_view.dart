import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/provider/mod_list_provider.dart';
import 'package:modmopet/src/service/routine.dart';
import '../../entity/mod.dart';

/// Displays a list of available mods for the game
class ModListView extends HookConsumerWidget {
  static const routeName = '/mod_list';
  const ModListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mods = ref.watch(modsProvider);
    final game = ref.watch(gameProvider);
    final source = ref.watch(sourceProvider);

    // Use memoized function to call update routine only on first build
    useMemoized(() async {
      await AppRoutineService.instance.checkForUpdate(game!, source!);
    });

    TabController tabController = useTabController(initialLength: 2);

    return Column(
      children: [
        Container(
          height: 150.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FastCachedImageProvider(game!.bannerUrl!),
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
                tabs: const [
                  Tab(
                    child: Icon(Icons.games_sharp),
                  ),
                  Tab(
                    child: Icon(Icons.gamepad),
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
              Container(
                child: mods.when(
                  loading: () => const SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (err, stack) => Text(err.toString()),
                  data: (mods) {
                    return buildListView(mods);
                  },
                ),
              ),
              const Text('no data.')
            ],
          ),
        ),
      ],
    );
  }

  Widget buildListView(List<Mod> mods) {
    return ListView.builder(
      restorationId: 'modListView',
      itemCount: mods.length,
      itemBuilder: (BuildContext context, int index) {
        final Mod mod = mods[index];
        return ListTile(
          title: Text(mod.title),
          leading: const Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.color_lens,
                size: 25.0,
              ),
              SizedBox(width: 8.0),
              Icon(
                Icons.circle,
                color: Colors.white60,
                size: 10.0,
              ),
            ],
          ),
          subtitle: mod.subtitle != null ? Text(mod.subtitle!) : const Text('Some subtitle'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  mod.author?['name'] != null ? Text('by ${mod.author?['name']}') : const Text('by unknown'),
                  Text('v${mod.version}'),
                ],
              ),
              const SizedBox(width: 8.0),
              OutlinedButton(
                onPressed: null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide.none,
                  textStyle: Theme.of(context).textTheme.labelMedium,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text('Activate'),
              ),
              const SizedBox(width: 8.0),
            ],
          ),
        );
      },
    );
  }
}
