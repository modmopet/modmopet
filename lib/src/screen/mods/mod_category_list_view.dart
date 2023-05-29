import 'package:flutter/material.dart';
import 'package:modmopet/src/config.dart';
import 'package:modmopet/src/entity/mod.dart';
import 'package:modmopet/src/service/mod.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';

class ModCategoryListView extends StatelessWidget {
  final int categoryId;
  final List<Mod> mods;
  ModCategoryListView({
    required this.categoryId,
    required this.mods,
    super.key,
  });

  String? getCategoryDescription(int categoryId) {
    final Map<int, String> categoryDescriptions = {
      1: 'The goal is to improve the performance and/or increase the frame rate.',
      2: 'Can improve graphics quality - sometimes at the expense of performance.',
      3: 'Extend and/or customize the user interface of the game.',
      4: 'Modifications that cannot be assigned to any category',
      5: 'Leverage effects such as damage, stamina, or other in-game effects',
      6: 'These are combined mods - mostly those that are to be used together anyway',
    };

    if (categoryDescriptions.containsKey(categoryId)) {
      return categoryDescriptions[categoryId];
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          title: Text(MMConfig().supportedCategories[categoryId]!),
          textColor: MMColors.instance.lightWhite,
          subtitle: Text(getCategoryDescription(categoryId) ?? ''),
          iconColor: MMColors.instance.primary,
          collapsedIconColor: MMColors.instance.primary,
          initiallyExpanded: true,
          children: [
            ListView.builder(
              shrinkWrap: true,
              restorationId: 'modCategory${categoryId}ListView',
              itemCount: mods.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                final Mod mod = mods[index];
                return ListTile(
                  title: Text(
                    mod.title,
                    maxLines: 1,
                  ),
                  dense: true,
                  shape: const Border(
                      bottom: BorderSide(
                    color: Colors.black,
                    width: 1,
                  )),
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
                  subtitle: mod.subtitle != null ? Text(mod.subtitle!) : const Text(''),
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
                      const SizedBox(width: 15.0),
                      ElevatedButton(
                        onPressed: () => ModService.instance.installMod(mod),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: MMColors.instance.primary,
                          foregroundColor: MMColors.instance.lightWhite,
                          textStyle: Theme.of(context).textTheme.labelMedium,
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.download,
                              size: 12.0,
                            ),
                            Text(
                              'Install',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8.0),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
