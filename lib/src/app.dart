import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/config.dart';
import 'package:modmopet/src/service/routine.dart';
import 'package:modmopet/src/widgets/mm_layout.dart';
import 'screen/settings/settings_controller.dart';
import 'screen/settings/settings_view.dart';
import 'themes/color_schemes.g.dart';

/// The Widget that configures your application.
class App extends HookConsumerWidget {
  const App({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

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
            restorationScopeId: 'modmopet',

            // Provide the generated AppLocalizations to the MaterialApp. This
            // allows descendant Widgets to display the correct translations
            // depending on the user's locale.
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            title: 'ModMopet',
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
                      title: const Text(MMConfig.title),
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
                    body: MMLayout(
                      settingsController: settingsController,
                      routeSettings: routeSettings,
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
