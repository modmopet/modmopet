import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/entity/git_source.dart';
import 'package:modmopet/src/entity/mod.dart';
import 'package:modmopet/src/screen/games/game_list_view.dart';
import 'package:modmopet/src/screen/mods/mods_list_view.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';
import 'package:modmopet/src/widgets/mm_breadcrumbs_bar.dart';
import 'package:url_launcher/url_launcher.dart';

/// Displays a list of available mods for the game
class ModsView extends HookConsumerWidget {
  static const routeName = '/mod_list';
  const ModsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);

    useMemoized(() => ref.watch(updateSourcesProvider));

    return Column(
      children: [
        MMBreadcrumbsBar('Games - ${game?.title} - Modifications', GameListView.routeName),
        SizedBox(
          height: 180.0,
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20.0),
                      width: 140,
                      decoration: BoxDecoration(
                        color: MMColors.instance.background,
                        image: DecorationImage(
                          image: FastCachedImageProvider(game!.iconUrl),
                          alignment: Alignment.topLeft,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const SizedBox(
                              width: 75.0,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Id:'),
                                  Text('Title:'),
                                  Text('Version:'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(game.id),
                                  AutoSizeText(game.title, maxLines: 1),
                                  Text(game.version),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 45,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            border: Border.symmetric(horizontal: BorderSide(width: 1, color: MMColors.instance.backgroundBorder)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              createActionMenu(context, ref),
              createSourceMenu(context, ref),
            ],
          ),
        ),
        const Expanded(
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: ModsListView(),
          ),
        ),
      ],
    );
  }
}

Widget createActionMenu(BuildContext context, WidgetRef ref) {
  return Row(
    children: [
      IconButton(
        tooltip: 'Reload',
        onPressed: () => ref.invalidate(modsProvider),
        color: MMColors.instance.primary,
        icon: const Icon(
          Icons.refresh_outlined,
          size: 24.0,
        ),
      ),
    ],
  );
}

Future<void> _launchWebsite(String uri) async {
  Uri url = Uri.parse(uri);
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}

Widget createSourceMenu(BuildContext context, WidgetRef ref) {
  final selectedSource = ref.watch(selectedSourceProvider);
  return Row(
    children: [
      const Text('Source: '),
      const SizedBox(width: 8.0),
      createSourceDropdown(context, ref),
      IconButton(
        tooltip: 'Open Github',
        onPressed: () => _launchWebsite(selectedSource!.uri),
        icon: const Icon(
          Icons.open_in_browser_outlined,
          size: 24.0,
        ),
      ),
      const IconButton(
        tooltip: 'Not yet implemented',
        onPressed: null,
        icon: Icon(
          Icons.settings_outlined,
          size: 24.0,
        ),
      ),
    ],
  );
}

Widget createSourceDropdown(BuildContext context, WidgetRef ref) {
  final availableSources = ref.watch(gitSourcesProvider);
  final selectedSource = ref.watch(selectedSourceProvider);
  return DropdownButtonHideUnderline(
    child: DropdownButton2(
      buttonStyleData: ButtonStyleData(
        height: 35,
        width: 250,
        padding: const EdgeInsets.only(left: 14, right: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: MMColors.instance.backgroundBorder,
          ),
          color: MMColors.instance.background,
        ),
        elevation: 2,
      ),
      iconStyleData: IconStyleData(
        icon: const Icon(
          Icons.arrow_forward_ios_outlined,
        ),
        iconSize: 14,
        iconEnabledColor: MMColors.instance.primary,
        iconDisabledColor: Colors.grey,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 400,
        width: 250,
        padding: null,
        decoration: BoxDecoration(
          color: MMColors.instance.backgroundBorder,
        ),
        elevation: 8,
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(40),
          thickness: MaterialStateProperty.all<double>(6),
          thumbVisibility: MaterialStateProperty.all<bool>(true),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        height: 40,
        padding: EdgeInsets.only(left: 14, right: 14),
      ),
      hint: const Row(
        children: [
          Text('Test'),
        ],
      ),
      items: availableSources
          .map((source) => DropdownMenuItem<GitSource>(
                value: source,
                child: Text(
                  source.repository,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
      value: selectedSource,
      onChanged: (value) {
        ref.read(selectedSourceProvider.notifier).select(value!);
      },
    ),
  );
}
