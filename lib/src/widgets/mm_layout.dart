import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/provider/emulator_provider.dart';
import 'package:modmopet/src/screen/emulator_not_found/emulator_not_found_view.dart';
import 'package:modmopet/src/screen/games/game_list_view.dart';
import 'package:modmopet/src/screen/mods/mods_view.dart';
import 'package:modmopet/src/screen/emulator_picker/emulator_picker_view.dart';
import 'package:modmopet/src/screen/settings/settings_controller.dart';
import 'package:modmopet/src/screen/settings/settings_view.dart';
import 'package:modmopet/src/service/logger.dart';
import 'package:modmopet/src/themes/color_schemes.g.dart';
import 'package:modmopet/src/widgets/mm_draggable_appbar.dart';
import 'package:modmopet/src/widgets/mm_navigation_rail.dart';
import 'package:updat/theme/chips/floating_with_silent_download.dart';
import 'package:updat/updat_window_manager.dart';

class MMLayout extends HookConsumerWidget {
  final String version;
  final SettingsController settingsController;
  final RouteSettings routeSettings;
  const MMLayout({
    required this.settingsController,
    required this.routeSettings,
    required this.version,
    super.key,
  });

  Widget getScreenByRoute(RouteSettings routeSettings, WidgetRef ref) {
    final selectedEmulator = ref.watch(selectedEmulatorProvider);
    switch (routeSettings.name) {
      case SettingsView.routeName:
        return SettingsView(controller: settingsController);
      case GameListView.routeName:
        return const GameListView();
      case ModsView.routeName:
        return const ModsView();
      case EmulatorNotFoundView.routeName:
        return const EmulatorNotFoundView();
      default:
        return selectedEmulator.value == null
            ? const EmulatorPickerView()
            : const GameListView();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UpdatWindowManager(
      appName: 'ModMopet',
      getLatestVersion: () async {
        final data = await Dio().get(
            'https://api.github.com/repos/modmopet/modmopet/releases/latest');
        if (data.statusCode != 200) {
          return null;
        }
        return data.data["tag_name"].toString().substring(1);
      },
      getBinaryUrl: (version) async {
        final data = await Dio().get(
            'https://api.github.com/repos/modmopet/modmopet/releases/$version');
        if (data.statusCode != 200) {
          return '';
        }
        List<Map<String, dynamic>> assets = jsonDecode(data.data)["assets"];
        Map<String, dynamic> asset = assets.firstWhere((asset) =>
            asset["name"].toString().contains(Platform.operatingSystem));

        return asset["browser_download_url"];
      },
      getChangelog: (latestVersion, appVersion) async {
        // Call github api to get commits between versions
        final data = await Dio().get(
            'https://api.github.com/repos/modmopet/modmopet/compare/v$appVersion...v$latestVersion');
        if (data.statusCode != 200) {
          return 'Unable to retrieve changelog';
        }
        return (data.data["commits"] as List).reduce(
            (value, element) => value + '\n' + element["commit"]["message"]);
      },
      updateChipBuilder: floatingExtendedChipWithSilentDownload,
      // Get current version from pubspec.yaml
      currentVersion: version,
      callback: (status) {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // TOP BAR
          const DraggableAppBar(),
          Expanded(
            child: Row(
              children: [
                // NAVIGATOIN RAIL
                Container(
                  width: 100.0,
                  decoration: BoxDecoration(
                    color: MMColors.instance.background,
                    border: Border(
                      right:
                          BorderSide(color: MMColors.instance.backgroundBorder),
                    ),
                  ),
                  child: const MMNavigationRail(),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // CONTENT
                      Expanded(
                        child: Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: getScreenByRoute(routeSettings, ref),
                        ),
                      ),
                      // FOOTER BAR
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: MMColors.instance.background,
                          border: Border(
                            top: BorderSide(
                                width: 1.0,
                                color: MMColors.instance.backgroundBorder),
                          ),
                        ),
                        width: double.infinity,
                        height: 32.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: ListenableBuilder(
                            listenable: LoggerService.instance,
                            builder: (context, widget) {
                              return LoggerService.instance.messages.isNotEmpty
                                  ? Text(
                                      LoggerService.instance.messages.last,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color:
                                                  MMColors.instance.bodyText),
                                    )
                                  : Container();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String get platformExt {
  switch (Platform.operatingSystem) {
    case 'windows':
      return 'zip';
    case 'macos':
      return 'tar.gz';
    case 'linux':
      return 'tar.gz';
    default:
      return 'zip';
  }
}
