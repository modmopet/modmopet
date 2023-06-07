import 'package:flutter/material.dart';

import '../provider/setting_provider.dart';
import 'storage.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  static final SettingsService _instance = SettingsService();
  static SettingsService get instance => _instance;

  /// An enum representing the current theme mode
  final Setting<ThemeMode> themeMode = Setting<ThemeMode>(SettingsKeys.themeMode, ThemeMode.system);
  final Setting<String> emulatorId = Setting<String>(SettingsKeys.emulatorId, 'yuzu');
  
  /// Load the user's settings from the local storage
  /// 
  /// This method should be called when the app starts
  void load() async {
    final settingsThemeMode = await StorageService.instance.get(themeMode.key);
    if (settingsThemeMode != null) themeMode.value = ThemeMode.values.firstWhere((e) => e.name == settingsThemeMode);
  }

  /// Save the user's settings to the local storage
  /// 
  /// This method should be called when the user changes a setting or when he press `save` button
  /// Settings can be applyed without saving them so restarting the app will restore the previous settings
  Future<void> save() async {
    // save the theme mode only if it is not null
    // if it is null, it means that the user didn't change the theme mode
    // so we don't need to save it
    if (themeMode.isNotNull) {
      // write the theme mode to the local storage
      await StorageService.instance.set(themeMode.key, themeMode.value.name);
    }
    if (emulatorId.isNotNull) {
      await StorageService.instance.set(emulatorId.key, emulatorId.value);
    }
  }
}

// Enum to store the keys for the user's settings
enum SettingsKeys {
  themeMode,
  emulatorId
}