import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/screen/mods/mod_list_provider.dart';
import 'package:modmopet/src/service/routine.dart';

import '../settings/settings_view.dart';
import '../../entity/mod.dart';

/// Displays a list of available mods for the game
class ModListView extends HookConsumerWidget {
  static const routeName = '/mod_list';
  const ModListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mods = ref.watch(modsProvider);
    final game = ref.watch(gameProvider);
    AppRoutineService.instance.checkForUpdate(game, game.sources.first);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(game.title),
          flexibleSpace: game.bannerUrl != null
              ? Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      opacity: 0.5,
                      image: Image.network(game.bannerUrl!).image,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Container(),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Mods',
                icon: Icon(Icons.extension),
              ),
              Tab(
                text: 'Cheats',
                icon: Icon(Icons.games_rounded),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        body: TabBarView(
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
          shape: const BorderDirectional(
            bottom: BorderSide(width: 1.0),
          ),
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
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
              const ElevatedButton(
                onPressed: null,
                child: Text('Activate'),
              ),
              const SizedBox(width: 8.0),
            ],
          ),
        );
      },
    );
  }
}
