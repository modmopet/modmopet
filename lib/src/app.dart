import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/screen/games/game_list_view.dart';
import 'package:modmopet/src/service/logger.dart';
import 'package:modmopet/src/service/routine.dart';
import 'package:modmopet/src/widgets/mm_icon_button.dart';
import 'screen/mods/mod_list_view.dart';
import 'screen/settings/settings_controller.dart';
import 'screen/settings/settings_view.dart';
import 'themes/color_schemes.g.dart';

/// The Widget that configures your application.
class App extends ConsumerWidget {
  const App({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

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
    // Start app routines
    AppRoutineService.instance.checkAppHealth();

    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return ProviderScope(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            // Providing a restorationScopeId allows the Navigator built by the
            // MaterialApp to restore the navigation stack when a user leaves and
            // returns to the app after it has been killed while running in the
            // background.
            restorationScopeId: 'app',

            // Provide the generated AppLocalizations to the MaterialApp. This
            // allows descendant Widgets to display the correct translations
            // depending on the user's locale.
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
            ],

            // Use AppLocalizations to configure the correct application title
            // depending on the user's locale.
            //
            // The appTitle is defined in .arb files found in the localization
            // directory.
            onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,

            // Define a light and dark color theme. Then, read the user's
            // preferred ThemeMode (light, dark, or system default) from the
            // SettingsController to display the correct theme.
            theme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
            darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
            themeMode: settingsController.themeMode,

            // Define a function to handle named routes in order to support
            // Flutter web url navigation and deep linking.
            onGenerateRoute: (RouteSettings routeSettings) {
              return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('ModMopet'),
                      titleSpacing: 10.0,
                      titleTextStyle: const TextStyle(fontSize: 15.0),
                      toolbarHeight: 38.0,
                      centerTitle: true,
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            Navigator.restorablePushNamed(context, SettingsView.routeName);
                          },
                        ),
                      ],
                    ),
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 100.0,
                                decoration: const BoxDecoration(border: Border(right: BorderSide(width: 1))),
                                child: const Column(
                                  children: [
                                    MMIconButton.active(width: double.infinity, height: 75, icon: Icons.view_list),
                                    MMIconButton(width: double.infinity, height: 75, icon: Icons.gamepad),
                                    MMIconButton(width: double.infinity, height: 75, icon: Icons.light_sharp),
                                    MMIconButton(width: double.infinity, height: 75, icon: Icons.amp_stories),
                                  ],
                                ),
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
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(color: Colors.grey),
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
                },
              );
            },
          ),
        );
      },
    );
  }
}
