import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/entity/mod.dart';
import 'package:modmopet/src/widgets/mm_filter_tag.dart';

class ModFilterRowWidget extends ConsumerWidget {
  const ModFilterRowWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: createGameVersionsTagContainer(ref),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: createModStateTagContainer(ref),
        ),
      ],
    );
  }

  Widget createGameVersionsTagContainer(WidgetRef ref) {
    List<Widget> tags = [];
    final gameVersions = ref.watch(gameVersionsProvider);
    final gameVersionFilter = ref.watch(gameVersionFilterProvider);
    tags.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: MMFilterTag(
          active: gameVersionFilter == null,
          onPressed: () => ref.read(gameVersionFilterProvider.notifier).state = null,
          text: 'all',
        ),
      ),
    );
    for (final version in gameVersions) {
      tags.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: MMFilterTag(
            active: gameVersionFilter == version,
            onPressed: () => ref.read(gameVersionFilterProvider.notifier).state = version,
            text: 'v$version',
          ),
        ),
      );
    }

    return Row(children: tags);
  }

  Widget createModStateTagContainer(WidgetRef ref) {
    List<Widget> tags = [];
    final stateFilter = ref.watch(modStateFilterProvider);
    for (final ModStateFilter filter in ModStateFilter.values) {
      tags.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: MMFilterTag(
            active: stateFilter == filter,
            onPressed: () => ref.read(modStateFilterProvider.notifier).state = filter,
            text: filter.name,
          ),
        ),
      );
    }

    return Row(children: tags);
  }
}
