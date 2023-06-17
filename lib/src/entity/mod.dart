import 'dart:core';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modmopet/src/entity/emulator.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/entity/git_source.dart';
import 'package:modmopet/src/repository/mods.dart';
import 'package:modmopet/src/service/loading.dart';
import 'package:modmopet/src/service/mod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
part 'mod.freezed.dart';
part 'mod.g.dart';

@freezed
class Mod with _$Mod {
  const Mod._();
  const factory Mod({
    required final String id,
    required final String title,
    required final Category category,
    required final String? version,
    required final Map<dynamic, dynamic> game,
    required final String origin,
    final String? subtitle,
    final String? description,
    final List<dynamic>? author,
    @Default(false) final bool isInstalled,
    @Default(false) final bool hasUpdate,
  }) = _Mod;

  factory Mod.fromYaml(
    dynamic yaml,
    String origin, {
    bool isInstalled = false,
    bool hasUpdate = false,
  }) {
    return _Mod(
      id: yaml['id'],
      title: yaml['title'],
      subtitle: yaml['subtitle'],
      description: yaml['description'],
      category: Category.values.singleWhere(
        (category) => category.id == yaml['category'] as int,
      ),
      version: yaml['version'] is int ? yaml['version'].toString() : yaml['version'] as String?,
      game: yaml['game'],
      origin: origin,
      author: yaml['author'],
      isInstalled: isInstalled,
      hasUpdate: hasUpdate,
    );
  }
}

enum ModStateFilter {
  all,
  installed,
  notInstalled,
  hasUpdate,
}

final modStateFilterProvider = StateProvider<ModStateFilter>((ref) => ModStateFilter.all);
final gameVersionsProvider = StateProvider<Set<String>>((ref) => <String>{});
final gameVersionFilterProvider = StateProvider<String?>((ref) => null);

@riverpod
Future<List<Mod>> availableMods(AvailableModsRef ref) async {
  final emulator = ref.watch(emulatorProvider);
  final game = ref.watch(gameProvider);
  final gitSources = ref.watch(gitSourcesProvider);
  final selectedGitSource = ref.watch(selectedSourceProvider);

  if (gitSources.isEmpty) {
    return [];
  }

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await LoadingService.instance.show('Mods will be delivered...');
  });

  return await ModsRepository().getAvailableMods(
    emulator.value!,
    game!,
    selectedGitSource ?? gitSources.first,
    ref,
  );
}

@riverpod
class Mods extends _$Mods {
  Future<List<Mod>> _fetchMods() async {
    final mods = await ref.watch(availableModsProvider.future);
    final modStateFilter = ref.watch(modStateFilterProvider);
    final versionFilter = ref.watch(gameVersionFilterProvider);

    // 1. Filter mods by category and filter
    final List<Mod> filteredMods = mods.where((mod) {
      switch (modStateFilter) {
        case ModStateFilter.all:
          return mod.category.id == category.id;
        case ModStateFilter.installed:
          return mod.category.id == category.id && mod.isInstalled;
        case ModStateFilter.notInstalled:
          return mod.category.id == category.id && !mod.isInstalled;
        case ModStateFilter.hasUpdate:
          return mod.category.id == category.id && mod.hasUpdate;
      }
    }).toList();

    // 2. Filter mods by game version
    if (versionFilter != null) {
      filteredMods.removeWhere((mod) {
        final gameVersion = ref.watch(gameVersionFilterProvider.notifier).state;
        return !mod.game['version'].contains(gameVersion);
      });
    }

    // 3. Sort by title
    filteredMods.sort((a, b) => a.title.compareTo(b.title));

    await LoadingService.instance.clear();

    return filteredMods;
  }

  @override
  FutureOr<List<Mod>> build(Category category) async => _fetchMods();

  Future<void> installMod(Emulator emulator, Game game, Mod mod) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ModService.instance.installMod(game.id, mod, emulator);
      ref.invalidate(availableModsProvider);
      return _fetchMods();
    });
  }

  Future<void> updateMod(Emulator emulator, Game game, Mod mod) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      ModService.instance.updateMod(game.id, mod, emulator);
      try {
        await ModService.instance.removeMod(game.id, mod, emulator);
        ref.invalidate(availableModsProvider);
      } catch (error, stackTrace) {
        Sentry.captureException(error, stackTrace: stackTrace);
      }

      return _fetchMods();
    });
  }

  Future<void> removeMod(Emulator emulator, Game game, Mod mod) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        await ModService.instance.removeMod(game.id, mod, emulator);
        ref.invalidate(availableModsProvider);
      } catch (error, stackTrace) {
        Sentry.captureException(error, stackTrace: stackTrace);
      }

      return _fetchMods();
    });
  }
}

enum Category {
  performance(
    id: 1,
    name: 'Performance',
    description: 'The goal is to improve the performance and/or increase the frame rate.',
    icon: Icon(Icons.speed_outlined, size: 28.0),
  ),
  graphics(
    id: 2,
    name: 'Graphics',
    description: 'Can improve graphics quality - sometimes at the expense of performance.',
    icon: Icon(Icons.monitor_outlined, size: 28.0),
  ),
  ux(
    id: 3,
    name: 'UX/UI',
    description: 'Extend and/or customize the user interface of the game.',
    icon: Icon(Icons.widgets_outlined, size: 28.0),
  ),
  misc(
    id: 4,
    name: 'Misc',
    description: 'Modifications that cannot be assigned to any category',
    icon: Icon(Icons.circle_outlined, size: 28.0),
  ),
  cheats(
    id: 5,
    name: 'Cheats',
    description: 'Leverage effects such as damage, stamina, or other in-game effects',
    icon: Icon(Icons.favorite_outline, size: 28.0),
  ),
  combos(
    id: 6,
    name: 'Combos',
    description: 'These are combined mods - mostly those that are to be used together anyway',
    icon: Icon(Icons.merge_outlined, size: 28.0),
  );

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });

  final int id;
  final String name;
  final String description;
  final Icon icon;
}
