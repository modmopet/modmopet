import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modmopet/src/service/storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:window_manager/window_manager.dart';
import 'src/app.dart';
import 'src/screen/settings/settings_controller.dart';
import 'src/screen/settings/settings_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

const String emulatorBoxName = 'emulator';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  String imageCacheDirectory =
      '${(await getApplicationSupportDirectory()).path}${Platform.pathSeparator}image_cache';
  await FastCachedImageConfig.init(
      subDir: imageCacheDirectory, clearCacheAfter: const Duration(days: 30));

  if (kDebugMode) {
    final prefs = await StorageService.instance.prefs;
    prefs.clear();
  }

  // Set window settings
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1200, 800),
    minimumSize: Size(1000, 700),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    title: 'ModMopet',
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  final supportedLocales = [
    const Locale('en', 'US'),
    const Locale('de', 'DE'),
    const Locale('fr', 'FR'),
    const Locale('es', 'ES'),
    const Locale('it', 'IT'),
    const Locale('pt', 'BR'),
    const Locale('pt', 'PT')
  ];

  String version = await _getVersion();

  // Sentry implementation
  await SentryFlutter.init(
    (options) {
      options.dsn = const String.fromEnvironment('MM_SENTRY_DSN');
      options.tracesSampleRate = double.parse(
        const String.fromEnvironment('MM_SENTRY_TRACE_SAMPLE_RATE',
            defaultValue: '0.5'),
      );
    },
    appRunner: () => runApp(
      EasyLocalization(
        supportedLocales: supportedLocales,
        path: 'assets/translations',
        child: App(version: version, settingsController: settingsController),
      ),
    ),
  );
}

Future<String> _getVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  return packageInfo.version;
}
