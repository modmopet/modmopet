
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/settings.dart';

/// A class that represents a setting that can be customized by the user. And it can be listened to by Widgets.
class Setting<T> extends StateNotifier<T> {
  /// The key used to store the setting in the local storage
  late final SettingsKeys _key;
  /// The value of the setting
  T? _value;
  /// The default value of the setting if needed
  final T defaultValue;

  Setting(this._key, this.defaultValue) : super(defaultValue);

  /// Get the value of the setting
  T get value => _value ?? defaultValue;

  /// Set the value of the setting and notify listeners
  set value (T? newValue) {
    if (value == newValue) return;

    _value = newValue;
  }

  // Helper method to convert enum to the settings key string
  String get key {
    // transform enum to snake case string
    final enumString = _key.toString().split('.').last.replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match.group(0)!.toLowerCase()}');
    return 'settings_$enumString';
  }

  StateNotifierProvider<Setting<T>, T> get provider => StateNotifierProvider<Setting<T>, T>((ref) => this);

  bool get isDefault => value == defaultValue;
  bool get isNotDefault => !isDefault;
  bool get isNull => _value == null;
  bool get isNotNull => !isNull;
}
