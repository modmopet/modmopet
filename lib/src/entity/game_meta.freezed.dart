// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GameMeta {
  String get title => throw _privateConstructorUsedError;
  bool get favorite => throw _privateConstructorUsedError;
  int get playTime => throw _privateConstructorUsedError;
  DateTime? get lastPlayed => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GameMetaCopyWith<GameMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameMetaCopyWith<$Res> {
  factory $GameMetaCopyWith(GameMeta value, $Res Function(GameMeta) then) =
      _$GameMetaCopyWithImpl<$Res, GameMeta>;
  @useResult
  $Res call({String title, bool favorite, int playTime, DateTime? lastPlayed});
}

/// @nodoc
class _$GameMetaCopyWithImpl<$Res, $Val extends GameMeta>
    implements $GameMetaCopyWith<$Res> {
  _$GameMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? favorite = null,
    Object? playTime = null,
    Object? lastPlayed = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      favorite: null == favorite
          ? _value.favorite
          : favorite // ignore: cast_nullable_to_non_nullable
              as bool,
      playTime: null == playTime
          ? _value.playTime
          : playTime // ignore: cast_nullable_to_non_nullable
              as int,
      lastPlayed: freezed == lastPlayed
          ? _value.lastPlayed
          : lastPlayed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GameMetaCopyWith<$Res> implements $GameMetaCopyWith<$Res> {
  factory _$$_GameMetaCopyWith(
          _$_GameMeta value, $Res Function(_$_GameMeta) then) =
      __$$_GameMetaCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, bool favorite, int playTime, DateTime? lastPlayed});
}

/// @nodoc
class __$$_GameMetaCopyWithImpl<$Res>
    extends _$GameMetaCopyWithImpl<$Res, _$_GameMeta>
    implements _$$_GameMetaCopyWith<$Res> {
  __$$_GameMetaCopyWithImpl(
      _$_GameMeta _value, $Res Function(_$_GameMeta) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? favorite = null,
    Object? playTime = null,
    Object? lastPlayed = freezed,
  }) {
    return _then(_$_GameMeta(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      favorite: null == favorite
          ? _value.favorite
          : favorite // ignore: cast_nullable_to_non_nullable
              as bool,
      playTime: null == playTime
          ? _value.playTime
          : playTime // ignore: cast_nullable_to_non_nullable
              as int,
      lastPlayed: freezed == lastPlayed
          ? _value.lastPlayed
          : lastPlayed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$_GameMeta extends _GameMeta {
  _$_GameMeta(
      {required this.title,
      required this.favorite,
      required this.playTime,
      required this.lastPlayed})
      : super._();

  @override
  final String title;
  @override
  final bool favorite;
  @override
  final int playTime;
  @override
  final DateTime? lastPlayed;

  @override
  String toString() {
    return 'GameMeta(title: $title, favorite: $favorite, playTime: $playTime, lastPlayed: $lastPlayed)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GameMeta &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.favorite, favorite) ||
                other.favorite == favorite) &&
            (identical(other.playTime, playTime) ||
                other.playTime == playTime) &&
            (identical(other.lastPlayed, lastPlayed) ||
                other.lastPlayed == lastPlayed));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, title, favorite, playTime, lastPlayed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GameMetaCopyWith<_$_GameMeta> get copyWith =>
      __$$_GameMetaCopyWithImpl<_$_GameMeta>(this, _$identity);
}

abstract class _GameMeta extends GameMeta {
  factory _GameMeta(
      {required final String title,
      required final bool favorite,
      required final int playTime,
      required final DateTime? lastPlayed}) = _$_GameMeta;
  _GameMeta._() : super._();

  @override
  String get title;
  @override
  bool get favorite;
  @override
  int get playTime;
  @override
  DateTime? get lastPlayed;
  @override
  @JsonKey(ignore: true)
  _$$_GameMetaCopyWith<_$_GameMeta> get copyWith =>
      throw _privateConstructorUsedError;
}
