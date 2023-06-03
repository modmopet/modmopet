import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/entity/mod.dart';
import 'package:modmopet/src/provider/emulator_provider.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';
import 'package:modmopet/src/widgets/mm_evelated_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tinycolor2/tinycolor2.dart';

class ModListItem extends ConsumerWidget {
  const ModListItem(
    this.mod,
    this.isEven, {
    super.key,
  });
  final Mod mod;
  final bool isEven;

  Future<void> _launchAuthorLink(String uri) async {
    Uri url = Uri.parse(uri);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  List<Widget> createAuthorsTextLinks(List<dynamic>? authors) {
    List<Widget> authorsLinks = [];

    if (authors != null && authors.isNotEmpty) {
      for (Map author in authors) {
        authorsLinks.add(
          InkWell(
            onTap: author['link'] != null ? () => _launchAuthorLink(author['link']) : null,
            child: author['name'] != null ? Text(author['name']) : const Text('unknown'),
          ),
        );
      }
    }

    return authorsLinks;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: isEven == true ? Colors.black87 : null,
      ),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 8.0),
            Icon(
              Icons.circle,
              color: mod.hasUpdate ? MMColors.instance.primary.complement() : MMColors.instance.primary,
              size: 10.0,
            ),
          ],
        ),
        title: Text(
          mod.title,
          maxLines: 1,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: mod.subtitle != null ? Text(mod.subtitle!, style: Theme.of(context).textTheme.bodySmall) : null,
        minVerticalPadding: 20.0,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ...createAuthorsTextLinks(mod.author),
                mod.version != null ? Text('v${mod.version!}') : Container(),
              ],
            ),
            const SizedBox(width: 15.0),
            ...buildActionButtons(ref),
            const SizedBox(width: 8.0),
          ],
        ),
      ),
    );
  }

  List<Widget> buildActionButtons(WidgetRef ref) {
    final List<Widget> actionButtons = [];

    // Show update button on installed mods which got an update available
    if (mod.isInstalled && mod.hasUpdate) {
      actionButtons.add(updateButton(ref));
      actionButtons.add(const SizedBox(width: 15.0));
    }

    // Show remove button or install button
    if (mod.isInstalled) {
      actionButtons.add(removeButton(ref));
    } else {
      actionButtons.add(installButton(ref));
    }

    return actionButtons;
  }

  Widget installButton(WidgetRef ref) {
    return MMElevatedButton.primary(
      onPressed: () {
        final emulator = ref.read(emulatorProvider).value;
        final game = ref.read(gameProvider);
        ref.read(modsProvider(mod.category).notifier).installMod(emulator!.filesystem, game!, mod);
      },
      child: const Row(
        children: [
          Icon(
            Icons.add_circle_outline,
            size: 12.0,
          ),
          SizedBox(width: 4.0),
          Text(
            'Install',
          ),
        ],
      ),
    );
  }

  Widget removeButton(WidgetRef ref) {
    return MMElevatedButton.secondary(
      onPressed: () {
        final emulator = ref.read(emulatorProvider).value;
        final game = ref.read(gameProvider);
        ref.read(modsProvider(mod.category).notifier).removeMod(emulator!.filesystem, game!, mod);
      },
      child: const Row(
        children: [
          Icon(
            Icons.remove_circle_outline,
            size: 12.0,
          ),
          SizedBox(width: 4.0),
          Text(
            'Remove',
          ),
        ],
      ),
    );
  }

  Widget updateButton(WidgetRef ref) {
    return MMElevatedButton(
      backgroundColor: MMColors.instance.primary.complement(),
      onPressed: () {
        final emulator = ref.read(emulatorProvider).value;
        final game = ref.read(gameProvider);
        ref.read(modsProvider(mod.category).notifier).updateMod(emulator!.filesystem, game!, mod);
      },
      child: const Row(
        children: [
          Icon(
            Icons.new_releases_outlined,
            size: 12.0,
          ),
          SizedBox(width: 4.0),
          Text(
            'Update available',
          ),
        ],
      ),
    );
  }
}
