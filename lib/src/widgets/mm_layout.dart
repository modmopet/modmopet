import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/entity/emulator.dart';
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

class MMLayout extends HookConsumerWidget {
  final SettingsController settingsController;
  final RouteSettings routeSettings;
  const MMLayout({
    required this.settingsController,
    required this.routeSettings,
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
        return selectedEmulator.value == null ? const EmulatorPickerView() : const GameListView();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
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
                    right: BorderSide(color: MMColors.instance.backgroundBorder),
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
                          top: BorderSide(width: 1.0, color: MMColors.instance.backgroundBorder),
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
                                        .copyWith(color: MMColors.instance.bodyText),
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
    );
  }
}
