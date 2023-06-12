import 'package:freezed_annotation/freezed_annotation.dart';
part 'stored_value.freezed.dart';

@freezed
class StoredValue<T> with _$StoredValue<T> {
  const StoredValue._();
  factory StoredValue({
    required StoredValueKeys key,
    required T? value,
    T? initialValue,
  }) = _StoredValue<T>;

  bool get isInitial => value == initialValue;
  bool get isNotInitial => !isInitial;
  bool get isNull => value == null;
  bool get isNotNull => !isNull;
}

// Available StoredValues keys for user settings from storage
enum StoredValueKeys {
  selectedEmulator(type: StoredValueKeyType.general),
  themeMode(type: StoredValueKeyType.settings);

  const StoredValueKeys({
    required this.type,
  });

  final StoredValueKeyType type;
}

enum StoredValueKeyType { general, settings }
