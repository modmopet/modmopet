// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mod.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Mod {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get category => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  Map<dynamic, dynamic> get game => throw _privateConstructorUsedError;
  String? get subtitle => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<dynamic, dynamic>? get author => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ModCopyWith<Mod> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModCopyWith<$Res> {
  factory $ModCopyWith(Mod value, $Res Function(Mod) then) =
      _$ModCopyWithImpl<$Res, Mod>;
  @useResult
  $Res call(
      {String id,
      String title,
      int category,
      String version,
      Map<dynamic, dynamic> game,
      String? subtitle,
      String? description,
      Map<dynamic, dynamic>? author});
}

/// @nodoc
class _$ModCopyWithImpl<$Res, $Val extends Mod> implements $ModCopyWith<$Res> {
  _$ModCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? category = null,
    Object? version = null,
    Object? game = null,
    Object? subtitle = freezed,
    Object? description = freezed,
    Object? author = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as int,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      game: null == game
          ? _value.game
          : game // ignore: cast_nullable_to_non_nullable
              as Map<dynamic, dynamic>,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as Map<dynamic, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ModCopyWith<$Res> implements $ModCopyWith<$Res> {
  factory _$$_ModCopyWith(_$_Mod value, $Res Function(_$_Mod) then) =
      __$$_ModCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      int category,
      String version,
      Map<dynamic, dynamic> game,
      String? subtitle,
      String? description,
      Map<dynamic, dynamic>? author});
}

/// @nodoc
class __$$_ModCopyWithImpl<$Res> extends _$ModCopyWithImpl<$Res, _$_Mod>
    implements _$$_ModCopyWith<$Res> {
  __$$_ModCopyWithImpl(_$_Mod _value, $Res Function(_$_Mod) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? category = null,
    Object? version = null,
    Object? game = null,
    Object? subtitle = freezed,
    Object? description = freezed,
    Object? author = freezed,
  }) {
    return _then(_$_Mod(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as int,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      game: null == game
          ? _value._game
          : game // ignore: cast_nullable_to_non_nullable
              as Map<dynamic, dynamic>,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      author: freezed == author
          ? _value._author
          : author // ignore: cast_nullable_to_non_nullable
              as Map<dynamic, dynamic>?,
    ));
  }
}

/// @nodoc

class _$_Mod extends _Mod {
  const _$_Mod(
      {required this.id,
      required this.title,
      required this.category,
      required this.version,
      required final Map<dynamic, dynamic> game,
      this.subtitle,
      this.description,
      final Map<dynamic, dynamic>? author})
      : _game = game,
        _author = author,
        super._();

  @override
  final String id;
  @override
  final String title;
  @override
  final int category;
  @override
  final String version;
  final Map<dynamic, dynamic> _game;
  @override
  Map<dynamic, dynamic> get game {
    if (_game is EqualUnmodifiableMapView) return _game;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_game);
  }

  @override
  final String? subtitle;
  @override
  final String? description;
  final Map<dynamic, dynamic>? _author;
  @override
  Map<dynamic, dynamic>? get author {
    final value = _author;
    if (value == null) return null;
    if (_author is EqualUnmodifiableMapView) return _author;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Mod(id: $id, title: $title, category: $category, version: $version, game: $game, subtitle: $subtitle, description: $description, author: $author)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Mod &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.version, version) || other.version == version) &&
            const DeepCollectionEquality().equals(other._game, _game) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._author, _author));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      category,
      version,
      const DeepCollectionEquality().hash(_game),
      subtitle,
      description,
      const DeepCollectionEquality().hash(_author));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ModCopyWith<_$_Mod> get copyWith =>
      __$$_ModCopyWithImpl<_$_Mod>(this, _$identity);
}

abstract class _Mod extends Mod {
  const factory _Mod(
      {required final String id,
      required final String title,
      required final int category,
      required final String version,
      required final Map<dynamic, dynamic> game,
      final String? subtitle,
      final String? description,
      final Map<dynamic, dynamic>? author}) = _$_Mod;
  const _Mod._() : super._();

  @override
  String get id;
  @override
  String get title;
  @override
  int get category;
  @override
  String get version;
  @override
  Map<dynamic, dynamic> get game;
  @override
  String? get subtitle;
  @override
  String? get description;
  @override
  Map<dynamic, dynamic>? get author;
  @override
  @JsonKey(ignore: true)
  _$$_ModCopyWith<_$_Mod> get copyWith => throw _privateConstructorUsedError;
}