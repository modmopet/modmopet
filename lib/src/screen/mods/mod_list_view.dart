import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/entity/mod.dart';
import 'package:modmopet/src/screen/mods/mod_list_item.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';
import 'package:modmopet/src/widgets/mm_loading_indicator.dart';

class ModListView extends ConsumerWidget {
  final Category category;
  const ModListView({
    required this.category,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modsByCategory = ref.watch(modsProvider(category));
    return Column(
      children: [
        ExpansionTile(
          title: Text(category.name),
          textColor: MMColors.instance.lightWhite,
          subtitle: Text(category.description),
          iconColor: MMColors.instance.primary,
          collapsedIconColor: MMColors.instance.primary,
          initiallyExpanded: true,
          children: [
            modsByCategory.when(
              skipLoadingOnRefresh: false,
              skipLoadingOnReload: true,
              data: (mods) => createListView(mods),
              error: (e, _) => Text(e.toString()),
              loading: () => MMLoadingIndicator(),
            ),
          ],
        ),
      ],
    );
  }

  Widget createListView(List<Mod> mods) {
    return ListView.builder(
      shrinkWrap: true,
      restorationId: 'modCategory${category.id}ListView',
      itemCount: mods.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, int index) {
        return ModListItem(mods[index]);
      },
    );
  }
}
