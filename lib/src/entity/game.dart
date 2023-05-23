import 'package:modmopet/src/entity/git_source.dart';

class Game {
  final String id;
  final String title;
  final String version;
  final List<GitSource> sources;
  final String? bannerUrl;

  Game({
    required this.id,
    required this.title,
    required this.version,
    required this.sources,
    this.bannerUrl,
  });
}
