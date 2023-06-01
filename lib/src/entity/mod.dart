import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/provider/emulator_provider.dart';
import 'package:modmopet/src/repository/mods.dart';
import 'package:modmopet/src/service/filesystem/emulator_filesystem.dart';
import 'package:modmopet/src/service/mod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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
    required final String path,
    final String? subtitle,
    final String? description,
    final List<dynamic>? author,
    @Default(false) final bool installed,
  }) = _Mod;
}

@riverpod
class Mods extends _$Mods {
  Future<List<Mod>> _fetchModsByCategory() async {
    final game = ref.watch(gameProvider);
    final emulator = ref.watch(emulatorProvider).value;

    // 1. Fetch mods
    final modsByCategory = await ModsRepository().getAvailableMods(emulator!, game!, game.sources.first);

    // 2. Filter mods by category
    final filteredMods = modsByCategory.where((element) => element.category.id == category.id).toList();

    // 3. Sort by title
    filteredMods.sort((a, b) => a.title.compareTo(b.title));

    return filteredMods;
  }

  @override
  FutureOr<List<Mod>> build(Category category) async => _fetchModsByCategory();

  Future<void> installMod(EmulatorFilesystemInterface filesystem, Game game, Mod mod) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ModService.instance.installMod(game, mod, filesystem);
      return _fetchModsByCategory();
    });
  }

  Future<void> updateMod(EmulatorFilesystemInterface filesystem, Mod mod) async {
    state = const AsyncValue.loading();
    ModService.instance.updateMod(mod, filesystem);
    state = await AsyncValue.guard(() async => await _fetchModsByCategory());
  }
}

enum Category {
  performance(
    id: 1,
    name: 'Performance',
    description: 'The goal is to improve the performance and/or increase the frame rate.',
  ),
  graphics(
      id: 2, name: 'Graphics', description: 'Can improve graphics quality - sometimes at the expense of performance.'),
  ux(id: 3, name: 'UX/UI', description: 'Extend and/or customize the user interface of the game.'),
  misc(id: 4, name: 'Misc', description: 'Modifications that cannot be assigned to any category'),
  cheats(id: 5, name: 'Cheats', description: 'Leverage effects such as damage, stamina, or other in-game effects'),
  combos(
      id: 6, name: 'Combos', description: 'These are combined mods - mostly those that are to be used together anyway');

  const Category({
    required this.id,
    required this.name,
    required this.description,
  });

  final int id;
  final String name;
  final String description;
}
