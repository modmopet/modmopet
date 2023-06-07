// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'git_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$updateSourcesHash() => r'b030c237395b732e02504eafad50e624ae4a0604';

/// See also [updateSources].
@ProviderFor(updateSources)
final updateSourcesProvider = AutoDisposeFutureProvider<void>.internal(
  updateSources,
  name: r'updateSourcesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateSourcesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UpdateSourcesRef = AutoDisposeFutureProviderRef<void>;
String _$gitSourcesHash() => r'049ae9c56dcaf630e425d025fdb73815edc25f09';

/// See also [GitSources].
@ProviderFor(GitSources)
final gitSourcesProvider =
    AutoDisposeNotifierProvider<GitSources, List<GitSource>>.internal(
  GitSources.new,
  name: r'gitSourcesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$gitSourcesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GitSources = AutoDisposeNotifier<List<GitSource>>;
String _$selectedSourceHash() => r'9373651c46642238b5060d0c1cf318902537057f';

/// See also [SelectedSource].
@ProviderFor(SelectedSource)
final selectedSourceProvider =
    AutoDisposeNotifierProvider<SelectedSource, GitSource?>.internal(
  SelectedSource.new,
  name: r'selectedSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedSource = AutoDisposeNotifier<GitSource?>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
