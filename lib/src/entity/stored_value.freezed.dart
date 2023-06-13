// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stored_value.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$StoredValue<T> {
  StoredValueKeys get key => throw _privateConstructorUsedError;
  T? get value => throw _privateConstructorUsedError;
  T? get initialValue => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $StoredValueCopyWith<T, StoredValue<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoredValueCopyWith<T, $Res> {
  factory $StoredValueCopyWith(
          StoredValue<T> value, $Res Function(StoredValue<T>) then) =
      _$StoredValueCopyWithImpl<T, $Res, StoredValue<T>>;
  @useResult
  $Res call({StoredValueKeys key, T? value, T? initialValue});
}

/// @nodoc
class _$StoredValueCopyWithImpl<T, $Res, $Val extends StoredValue<T>>
    implements $StoredValueCopyWith<T, $Res> {
  _$StoredValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? value = freezed,
    Object? initialValue = freezed,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as StoredValueKeys,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as T?,
      initialValue: freezed == initialValue
          ? _value.initialValue
          : initialValue // ignore: cast_nullable_to_non_nullable
              as T?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_StoredValueCopyWith<T, $Res>
    implements $StoredValueCopyWith<T, $Res> {
  factory _$$_StoredValueCopyWith(
          _$_StoredValue<T> value, $Res Function(_$_StoredValue<T>) then) =
      __$$_StoredValueCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({StoredValueKeys key, T? value, T? initialValue});
}

/// @nodoc
class __$$_StoredValueCopyWithImpl<T, $Res>
    extends _$StoredValueCopyWithImpl<T, $Res, _$_StoredValue<T>>
    implements _$$_StoredValueCopyWith<T, $Res> {
  __$$_StoredValueCopyWithImpl(
      _$_StoredValue<T> _value, $Res Function(_$_StoredValue<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? value = freezed,
    Object? initialValue = freezed,
  }) {
    return _then(_$_StoredValue<T>(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as StoredValueKeys,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as T?,
      initialValue: freezed == initialValue
          ? _value.initialValue
          : initialValue // ignore: cast_nullable_to_non_nullable
              as T?,
    ));
  }
}

/// @nodoc

class _$_StoredValue<T> extends _StoredValue<T> {
  _$_StoredValue({required this.key, required this.value, this.initialValue})
      : super._();

  @override
  final StoredValueKeys key;
  @override
  final T? value;
  @override
  final T? initialValue;

  @override
  String toString() {
    return 'StoredValue<$T>(key: $key, value: $value, initialValue: $initialValue)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_StoredValue<T> &&
            (identical(other.key, key) || other.key == key) &&
            const DeepCollectionEquality().equals(other.value, value) &&
            const DeepCollectionEquality()
                .equals(other.initialValue, initialValue));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      key,
      const DeepCollectionEquality().hash(value),
      const DeepCollectionEquality().hash(initialValue));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_StoredValueCopyWith<T, _$_StoredValue<T>> get copyWith =>
      __$$_StoredValueCopyWithImpl<T, _$_StoredValue<T>>(this, _$identity);
}

abstract class _StoredValue<T> extends StoredValue<T> {
  factory _StoredValue(
      {required final StoredValueKeys key,
      required final T? value,
      final T? initialValue}) = _$_StoredValue<T>;
  _StoredValue._() : super._();

  @override
  StoredValueKeys get key;
  @override
  T? get value;
  @override
  T? get initialValue;
  @override
  @JsonKey(ignore: true)
  _$$_StoredValueCopyWith<T, _$_StoredValue<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
