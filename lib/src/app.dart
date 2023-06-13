import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/service/github/github.dart';
import 'package:modmopet/src/widgets/mm_layout.dart';
import 'package:updat/theme/chips/default_with_check_for.dart';
import 'package:updat/updat_window_manager.dart';
import 'screen/settings/settings_controller.dart';
import 'themes/color_schemes.g.dart';

class SimplePageRoute<T> extends MaterialPageRoute<T> {
  SimplePageRoute({builder, settings}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}

/// The Widget that configures your application.
class App extends HookConsumerWidget {
  const App({
    super.key,
    required this.version,
    required this.settingsController,
  });

  final String version;
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return ProviderScope(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            restorationScopeId: 'modmopet',
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            title: 'ModMopet',
            theme:
                ThemeData(useMaterial3: true, colorScheme: darkColorScheme, dividerColor: MMColors.instance.background),
            darkTheme:
                ThemeData(useMaterial3: true, colorScheme: darkColorScheme, dividerColor: MMColors.instance.background),
            themeMode: settingsController.themeMode,
            onGenerateRoute: (RouteSettings routeSettings) {
              context.setLocale(const Locale('en', 'US'));
              final modmopetSlug = RepositorySlug('modmopet', 'modmopet');
              return SimplePageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  return UpdatWindowManager(
                    appName: 'ModMopet',
                    getLatestVersion: () async {
                      final latestRelease = await GithubClient().getLatestReleaseBySlug(modmopetSlug);
                      return latestRelease.tagName?.substring(1); // remove v from tag
                    },
                    getBinaryUrl: (version) async {
                      final latestRelease = await GithubClient().getLatestReleaseBySlug(modmopetSlug);
                      List<ReleaseAsset>? assets = latestRelease.assets;
                      ReleaseAsset asset =
                          assets!.firstWhere((asset) => asset.name!.contains(Platform.operatingSystem));
                      return asset.browserDownloadUrl!;
                    },
                    getChangelog: (latestVersion, appVersion) async {
                      final ReleaseNotes releaseNotes =
                          await GithubClient().generateReleaseNotes('v$latestVersion', 'v$appVersion');

                      return '${releaseNotes.name}\n\n${releaseNotes.body}';
                    },
                    updateChipBuilder: defaultChipWithCheckFor,
                    currentVersion: version,
                    openOnDownload: false,
                    closeOnInstall: true,
                    child: Material(
                      child: MMLayout(
                        version: version,
                        settingsController: settingsController,
                        routeSettings: routeSettings,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
