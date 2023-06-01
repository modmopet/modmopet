import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'git_source.freezed.dart';

@freezed
class GitSource with _$GitSource {
  const GitSource._();
  const factory GitSource({
    required String user,
    required String repository,
    required String root,
    required String branch,
  }) = _GitSource;

  String get uri => 'https://github.com/$user/$repository';
}

final sourceProvider = StateProvider<GitSource?>((ref) => null);
