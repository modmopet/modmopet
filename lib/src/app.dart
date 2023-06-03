import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/service/game.dart';
import 'package:modmopet/src/widgets/mm_layout.dart';
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
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useMemoized(() async {
      await GameService.instance.checkTitlesDatabase();
    });

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
            theme:
                ThemeData(useMaterial3: true, colorScheme: darkColorScheme, dividerColor: MMColors.instance.background),
            darkTheme:
                ThemeData(useMaterial3: true, colorScheme: darkColorScheme, dividerColor: MMColors.instance.background),
            themeMode: settingsController.themeMode,

            // Define a function to handle named routes in order to support
            // Flutter web url navigation and deep linking.
            onGenerateRoute: (RouteSettings routeSettings) {
              return SimplePageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  return Material(
                    child: MMLayout(
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
