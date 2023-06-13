import 'package:modmopet/src/entity/stored_value.dart';
import 'package:modmopet/src/service/storage/shared_preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
part 'settings.g.dart';

@riverpod
class Settings extends _$Settings {
  Future<List<StoredValue>> _loadSettings() async {
    final storage = SharedPreferencesStorage.instance;
    final List<StoredValue> storedValues = [];

    for (final storedValueKey in StoredValueKeys.values.where((e) => e.type == StoredValueKeyType.settings)) {
      storedValues.add(await storage.get(storedValueKey.name));
    }

    return storedValues;
  }

  @override
  FutureOr<List<StoredValue>> build() {
    return _loadSettings();
  }

  Future<void> save(StoredValue storedValue) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        SharedPreferencesStorage.instance.set(storedValue.key.name, storedValue.value);
      } catch (error, stackTrace) {
        Sentry.captureException(error, stackTrace: stackTrace);
      }

      return _loadSettings();
    });
  }
}
