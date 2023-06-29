import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/entity/emulator.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/entity/mod.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';
import 'package:modmopet/src/widgets/mm_evelated_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:yaml/yaml.dart';

class ModListItem extends HookConsumerWidget {
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

  Widget createAuthorsTextLinks(List<dynamic> authors, TextStyle textStyle) {
    List<TextSpan> authorsLinks = [];
    for (Map author in authors) {
      String? authorName = author['name'];
      String? authorLink = author['link'];

      authorsLinks.add(
        TextSpan(
          recognizer: TapGestureRecognizer()..onTap = authorLink != null ? () => _launchAuthorLink(authorLink) : null,
          mouseCursor: authorLink != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
          text: (authorName != null && authorName.isNotEmpty)
              ? author == authors.last
                  ? authorName
                  : '$authorName, '
              : 'unknown',
          style: textStyle.copyWith(
            fontWeight: (authorLink != null && authorLink.isNotEmpty) ? FontWeight.bold : FontWeight.normal,
            color: (authorLink != null && authorLink.isNotEmpty)
                ? MMColors.instance.secondary
                : MMColors.instance.lightWhite,
          ),
        ),
      );
    }

    return RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      textAlign: TextAlign.right,
      text: TextSpan(
        children: authorsLinks,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController = useAnimationController(
      duration: const Duration(seconds: 1),
    );
    final textTheme = Theme.of(context).textTheme;

    useEffect(() {
      animationController.forward();
      return null;
    }, const []);

    useAnimation(animationController);

    return Opacity(
      opacity: animationController.value,
      child: Container(
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
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mod.subtitle != null ? Text(mod.subtitle!, style: textTheme.bodySmall) : Container(),
              buildGameVersionCompatibility(mod, textTheme),
            ],
          ),
          minVerticalPadding: 18.0,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 300.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    mod.author != null
                        ? createAuthorsTextLinks(mod.author!, textTheme.bodySmall!)
                        : const Text('unknown'),
                    mod.version == null
                        ? Text('No version', style: textTheme.bodySmall!)
                        : Text('v${mod.version!}', style: textTheme.bodySmall!),
                  ],
                ),
              ),
              const SizedBox(width: 15.0),
              ...buildActionButtons(ref),
              const SizedBox(width: 8.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGameVersionCompatibility(Mod mod, TextTheme textTheme) {
    if (mod.game.isNotEmpty && mod.game.containsKey('version')) {
      final YamlList gameVersions = mod.game['version'];
      return Row(
        children: [
          Tooltip(
            message: 'Supported game versions',
            child: Text(
              gameVersions.map((e) => 'v$e').join(' | '),
              style: textTheme.bodySmall?.copyWith(color: MMColors.instance.secondary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    }

    return Container();
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
        ref.read(modsProvider(mod.category).notifier).installMod(emulator!, game!, mod);
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
        ref.read(modsProvider(mod.category).notifier).removeMod(emulator!, game!, mod);
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
        ref.read(modsProvider(mod.category).notifier).updateMod(emulator!, game!, mod);
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
