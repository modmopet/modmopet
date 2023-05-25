import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/screen/games/game_list_view.dart';
import 'package:modmopet/src/screen/mods/mod_list_view.dart';
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

  Widget getScreenByRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case SettingsView.routeName:
        return SettingsView(controller: settingsController);
      case GameListView.routeName:
        return const GameListView();
      case ModListView.routeName:
        return const ModListView();
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
        Expanded(
          child: Row(
            children: [
              Container(
                width: 100.0,
                decoration: const BoxDecoration(border: Border(right: BorderSide(width: 1))),
                child: const MMNavigationRail(),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: getScreenByRoute(routeSettings),
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
