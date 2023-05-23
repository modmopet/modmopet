import 'package:modmopet/src/entity/game.dart';
import 'package:modmopet/src/entity/git_source.dart';

class ModMopedConfig {
  final List<Game> games = [
    Game(
      id: '0100F2C011586000',
      title: 'The Legend of Zelda: Tears of the Kingdom',
      sources: [
        GitSource(
          user: 'HolographicWings',
          repository: 'TOTK-Mods-collection',
        ),
      ],
      version: '1.1.0',
      bannerUrl: 'https://images.gamebanana.com/img/Webpage/Game/Profile/Background/6428232e7ba08.jpg',
    ),
  ];
}
