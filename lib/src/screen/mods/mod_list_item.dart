import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/entity/mod.dart';
import 'package:modmopet/src/provider/emulator_provider.dart';
import 'package:modmopet/src/widgets/mm_evelated_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ModListItem extends ConsumerWidget {
  const ModListItem(
    this.mod, {
    super.key,
  });
  final Mod mod;

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
        authorsLinks.add(InkWell(
          onTap: author['link'] != null ? () => _launchAuthorLink(author['link']) : null,
          child: author['name'] != null ? Text(author['name']) : const Text('unknown'),
        ));
      }
    }

    return authorsLinks;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              ...createAuthorsTextLinks(mod.author),
              mod.version != null ? Text('v${mod.version!}') : Container(),
            ],
          ),
          const SizedBox(width: 15.0),
          mod.installed ? removeButton(ref) : installButton(ref),
          const SizedBox(width: 8.0),
        ],
      ),
    );
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
        // ref.read(modsProvider(mod.category).notifier).updateMod(emulator!.filesystem, game!, mod);
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
}
