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
    return ExpansionTile(
      title: Text(
        category.name,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontSize: 16.0, fontWeight: FontWeight.bold, color: MMColors.instance.primary),
      ),
      leading: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          category.icon,
          Text(
            modsByCategory.valueOrNull != null ? modsByCategory.valueOrNull!.length.toString() : '',
            style: TextStyle(
              color: MMColors.instance.bodyText,
            ),
          ),
        ],
      ),
      textColor: MMColors.instance.bodyText,
      subtitle: Text(
        category.description,
        style: TextStyle(
          color: MMColors.instance.bodyText,
        ),
      ),
      iconColor: MMColors.instance.bodyText,
      collapsedIconColor: MMColors.instance.primary,
      shape: Border(
        bottom: BorderSide(width: 2.0, color: MMColors.instance.backgroundBorder),
      ),
      collapsedShape: Border(
        bottom: BorderSide(width: 2.0, color: MMColors.instance.backgroundBorder),
      ),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      tilePadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 5.0,
      ),
      initiallyExpanded: true,
      children: [
        modsByCategory.when(
          skipLoadingOnRefresh: false,
          skipLoadingOnReload: true,
          data: (mods) => createListView(context, mods),
          error: (e, _) => Text(e.toString()),
          loading: () => MMLoadingIndicator(),
        ),
      ],
    );
  }

  Widget createListView(BuildContext context, List<Mod> mods) {
    final availableMods = mods.where((mod) => mod.isInstalled == false).toList();
    final installedMods = mods.where((mod) => mod.isInstalled == true).toList();
    return Column(
      children: [
        ...buildModList(context, 'Installed mods', Icons.check_circle_outline, installedMods),
        ...buildModList(context, 'Available mods', Icons.download_for_offline_outlined, availableMods),
      ],
    );
  }

  List<Widget> buildModList(BuildContext context, String title, IconData icon, List<Mod> mods) {
    if (mods.isNotEmpty) {
      return [
        Container(
          padding: const EdgeInsets.only(top: 10.0),
          margin: const EdgeInsets.only(bottom: 45.0),
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.black87, width: 1.0),
              top: BorderSide(color: Colors.black87, width: 0.7),
              right: BorderSide(color: Colors.black87, width: 1.0),
              bottom: BorderSide(color: Colors.black87, width: 1.2),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black26,
                Colors.black38,
              ],
            ),
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                height: 50.0,
                width: double.infinity,
                padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 10.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: MMColors.instance.primary, width: 1.0),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: MMColors.instance.bodyText,
                      size: 28.0,
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                restorationId: 'modCategory${category.id}ListView',
                itemCount: mods.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, int index) {
                  return ModListItem(mods[index], index.isEven);
                },
              ),
            ],
          ),
        ),
      ];
    }

    return [];
  }
}
