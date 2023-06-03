import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/provider/emulator_provider.dart';
import 'package:modmopet/src/screen/games/game_list_view.dart';
import 'package:modmopet/src/screen/mods/mods_view.dart';
import 'package:modmopet/src/screen/emulator_picker/emulator_picker_view.dart';
import 'package:modmopet/src/screen/settings/settings_controller.dart';
import 'package:modmopet/src/screen/settings/settings_view.dart';
import 'package:modmopet/src/service/logger.dart';
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
    // Select emulator on fresh application state, can be changed anytime
    final emulatorId = ref.watch(selectedEmulatorIdProvider.notifier).state;
    if (emulatorId == null) {
      return const EmulatorPickerView();
    }

    switch (routeSettings.name) {
      case SettingsView.routeName:
        return SettingsView(controller: settingsController);
      case GameListView.routeName:
        return const GameListView();
      case ModsView.routeName:
        return const ModsView();
      default:
        return const GameListView();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          height: 48.0,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // leading
              Container(),
              // center
              const Text('ModMopet'),
              // tailing
              Container(),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Container(
                width: 100.0,
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(),
                  ),
                ),
                child: const MMNavigationRail(),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: getScreenByRoute(routeSettings, ref),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        border: Border(
                          top: BorderSide(width: 1.0, color: Theme.of(context).shadowColor),
                        ),
                      ),
                      width: double.infinity,
                      height: 28.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListenableBuilder(
                          listenable: LoggerService.instance,
                          builder: (context, widget) {
                            return LoggerService.instance.messages.isNotEmpty
                                ? Text(
                                    LoggerService.instance.messages.last,
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),
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
