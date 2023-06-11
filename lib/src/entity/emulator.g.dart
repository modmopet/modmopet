// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emulator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$emulatorHash() => r'9792355add9cd4033e33e225c4210bbfc0444376';

/// See also [emulator].
@ProviderFor(emulator)
final emulatorProvider = AutoDisposeFutureProvider<Emulator?>.internal(
  emulator,
  name: r'emulatorProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$emulatorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef EmulatorRef = AutoDisposeFutureProviderRef<Emulator?>;
String _$selectedEmulatorHash() => r'95410287e997256cd74b414e1e504135c14a617d';

/// See also [SelectedEmulator].
@ProviderFor(SelectedEmulator)
final selectedEmulatorProvider =
    AutoDisposeAsyncNotifierProvider<SelectedEmulator, String?>.internal(
  SelectedEmulator.new,
  name: r'selectedEmulatorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedEmulatorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedEmulator = AutoDisposeAsyncNotifier<String?>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
