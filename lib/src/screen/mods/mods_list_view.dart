import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/entity/mod.dart';
import 'package:modmopet/src/screen/mods/mod_list_view.dart';

class ModsListView extends ConsumerWidget {
  const ModsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: createCategoryModLists(),
    );
  }

  List<Widget> createCategoryModLists() {
    List<ModListView> modListViews = [];
    for (var category in Category.values) {
      modListViews.add(ModListView(category: category));
    }
    return modListViews;
  }
}
