import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/entity/git_source.dart';

class MMConfig {
  static const String title = 'ModMopet';
  static const String version = 'dev-0.0.1';
  final Map<String, List<GitSource>> supportedSources = {
    "01006F8002326000": [
      const GitSource(user: 'HolographicWings', repository: 'TOTK-Mods-collection', root: 'Mods', branch: 'main'),
    ],
  };
}
