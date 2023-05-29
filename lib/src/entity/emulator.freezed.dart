// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'emulator.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Emulator {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  EmulatorFilesystemInterface get filesystem =>
      throw _privateConstructorUsedError;
  String? get path => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EmulatorCopyWith<Emulator> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmulatorCopyWith<$Res> {
  factory $EmulatorCopyWith(Emulator value, $Res Function(Emulator) then) =
      _$EmulatorCopyWithImpl<$Res, Emulator>;
  @useResult
  $Res call(
      {String id,
      String name,
      EmulatorFilesystemInterface filesystem,
      String? path});
}

/// @nodoc
class _$EmulatorCopyWithImpl<$Res, $Val extends Emulator>
    implements $EmulatorCopyWith<$Res> {
  _$EmulatorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? filesystem = null,
    Object? path = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      filesystem: null == filesystem
          ? _value.filesystem
          : filesystem // ignore: cast_nullable_to_non_nullable
              as EmulatorFilesystemInterface,
      path: freezed == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_EmulatorCopyWith<$Res> implements $EmulatorCopyWith<$Res> {
  factory _$$_EmulatorCopyWith(
          _$_Emulator value, $Res Function(_$_Emulator) then) =
      __$$_EmulatorCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      EmulatorFilesystemInterface filesystem,
      String? path});
}

/// @nodoc
class __$$_EmulatorCopyWithImpl<$Res>
    extends _$EmulatorCopyWithImpl<$Res, _$_Emulator>
    implements _$$_EmulatorCopyWith<$Res> {
  __$$_EmulatorCopyWithImpl(
      _$_Emulator _value, $Res Function(_$_Emulator) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? filesystem = null,
    Object? path = freezed,
  }) {
    return _then(_$_Emulator(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      filesystem: null == filesystem
          ? _value.filesystem
          : filesystem // ignore: cast_nullable_to_non_nullable
              as EmulatorFilesystemInterface,
      path: freezed == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_Emulator extends _Emulator {
  _$_Emulator(
      {required this.id,
      required this.name,
      required this.filesystem,
      this.path})
      : super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final EmulatorFilesystemInterface filesystem;
  @override
  final String? path;

  @override
  String toString() {
    return 'Emulator(id: $id, name: $name, filesystem: $filesystem, path: $path)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Emulator &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.filesystem, filesystem) ||
                other.filesystem == filesystem) &&
            (identical(other.path, path) || other.path == path));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, filesystem, path);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_EmulatorCopyWith<_$_Emulator> get copyWith =>
      __$$_EmulatorCopyWithImpl<_$_Emulator>(this, _$identity);
}

abstract class _Emulator extends Emulator {
  factory _Emulator(
      {required final String id,
      required final String name,
      required final EmulatorFilesystemInterface filesystem,
      final String? path}) = _$_Emulator;
  _Emulator._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  EmulatorFilesystemInterface get filesystem;
  @override
  String? get path;
  @override
  @JsonKey(ignore: true)
  _$$_EmulatorCopyWith<_$_Emulator> get copyWith =>
      throw _privateConstructorUsedError;
}
