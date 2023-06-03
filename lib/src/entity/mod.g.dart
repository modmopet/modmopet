// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$modsHash() => r'ef6cd7f0d81b18118eae92c2aa2da6c9721d21b6';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$Mods extends BuildlessAutoDisposeAsyncNotifier<List<Mod>> {
  late final Category category;

  FutureOr<List<Mod>> build(
    Category category,
  );
}

/// See also [Mods].
@ProviderFor(Mods)
const modsProvider = ModsFamily();

/// See also [Mods].
class ModsFamily extends Family<AsyncValue<List<Mod>>> {
  /// See also [Mods].
  const ModsFamily();

  /// See also [Mods].
  ModsProvider call(
    Category category,
  ) {
    return ModsProvider(
      category,
    );
  }

  @override
  ModsProvider getProviderOverride(
    covariant ModsProvider provider,
  ) {
    return call(
      provider.category,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'modsProvider';
}

/// See also [Mods].
class ModsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<Mods, List<Mod>> {
  /// See also [Mods].
  ModsProvider(
    this.category,
  ) : super.internal(
          () => Mods()..category = category,
          from: modsProvider,
          name: r'modsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$modsHash,
          dependencies: ModsFamily._dependencies,
          allTransitiveDependencies: ModsFamily._allTransitiveDependencies,
        );

  final Category category;

  @override
  bool operator ==(Object other) {
    return other is ModsProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  FutureOr<List<Mod>> runNotifierBuild(
    covariant Mods notifier,
  ) {
    return notifier.build(
      category,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
