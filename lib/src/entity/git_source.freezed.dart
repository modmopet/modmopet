// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'git_source.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GitSource {
  String get user => throw _privateConstructorUsedError;
  String get repository => throw _privateConstructorUsedError;
  String get root => throw _privateConstructorUsedError;
  String get branch => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GitSourceCopyWith<GitSource> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GitSourceCopyWith<$Res> {
  factory $GitSourceCopyWith(GitSource value, $Res Function(GitSource) then) =
      _$GitSourceCopyWithImpl<$Res, GitSource>;
  @useResult
  $Res call({String user, String repository, String root, String branch});
}

/// @nodoc
class _$GitSourceCopyWithImpl<$Res, $Val extends GitSource>
    implements $GitSourceCopyWith<$Res> {
  _$GitSourceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? repository = null,
    Object? root = null,
    Object? branch = null,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as String,
      repository: null == repository
          ? _value.repository
          : repository // ignore: cast_nullable_to_non_nullable
              as String,
      root: null == root
          ? _value.root
          : root // ignore: cast_nullable_to_non_nullable
              as String,
      branch: null == branch
          ? _value.branch
          : branch // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GitSourceCopyWith<$Res> implements $GitSourceCopyWith<$Res> {
  factory _$$_GitSourceCopyWith(
          _$_GitSource value, $Res Function(_$_GitSource) then) =
      __$$_GitSourceCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String user, String repository, String root, String branch});
}

/// @nodoc
class __$$_GitSourceCopyWithImpl<$Res>
    extends _$GitSourceCopyWithImpl<$Res, _$_GitSource>
    implements _$$_GitSourceCopyWith<$Res> {
  __$$_GitSourceCopyWithImpl(
      _$_GitSource _value, $Res Function(_$_GitSource) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? repository = null,
    Object? root = null,
    Object? branch = null,
  }) {
    return _then(_$_GitSource(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as String,
      repository: null == repository
          ? _value.repository
          : repository // ignore: cast_nullable_to_non_nullable
              as String,
      root: null == root
          ? _value.root
          : root // ignore: cast_nullable_to_non_nullable
              as String,
      branch: null == branch
          ? _value.branch
          : branch // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_GitSource extends _GitSource {
  const _$_GitSource(
      {required this.user,
      required this.repository,
      required this.root,
      required this.branch})
      : super._();

  @override
  final String user;
  @override
  final String repository;
  @override
  final String root;
  @override
  final String branch;

  @override
  String toString() {
    return 'GitSource(user: $user, repository: $repository, root: $root, branch: $branch)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GitSource &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.repository, repository) ||
                other.repository == repository) &&
            (identical(other.root, root) || other.root == root) &&
            (identical(other.branch, branch) || other.branch == branch));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, repository, root, branch);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GitSourceCopyWith<_$_GitSource> get copyWith =>
      __$$_GitSourceCopyWithImpl<_$_GitSource>(this, _$identity);
}

abstract class _GitSource extends GitSource {
  const factory _GitSource(
      {required final String user,
      required final String repository,
      required final String root,
      required final String branch}) = _$_GitSource;
  const _GitSource._() : super._();

  @override
  String get user;
  @override
  String get repository;
  @override
  String get root;
  @override
  String get branch;
  @override
  @JsonKey(ignore: true)
  _$$_GitSourceCopyWith<_$_GitSource> get copyWith =>
      throw _privateConstructorUsedError;
}
