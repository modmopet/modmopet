import 'package:modmopet/src/entity/git_source.dart';
import 'package:modmopet/src/service/filesystem/emulator/ryujinx_filesystem.dart';
import 'package:modmopet/src/service/filesystem/emulator/yuzu_filesystem.dart';

class MMConfig {
  static const String title = 'ModMopet';
  static const String version = 'dev-0.0.1';

  final Map<int, String> supportedCategories = {
    1: 'FPS/Performance',
    2: 'Graphics',
    3: 'UI/UX',
    4: 'Misc',
    5: 'Cheats',
    6: 'Combos',
  };

  Map<String, dynamic> supportedEmulators = {
    'yuzu': {
      'name': 'Yuzu',
      'url': 'https://yuzu-emu.org',
      'filesystem': YuzuFilesystem.instance,
    },
    'ryujinx': {
      'name': 'Ryujinx',
      'url': 'https://ryujinx.org',
      'filesystem': RyujinxFilesystem.instance,
    },
  };

  final Map<String, List<GitSource>> defaultSupportedSources = {
    "01006F8002326000": [
      const GitSource(user: 'HolographicWings', repository: 'TOTK-Mods-collection', root: 'Mods', branch: 'main'),
    ],
    "0100F2C0115B6000": [
      const GitSource(user: 'HolographicWings', repository: 'TOTK-Mods-collection', root: 'Mods', branch: 'main'),
    ]
  };
}
