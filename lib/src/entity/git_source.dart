class GitSource {
  final String user;
  final String repository;
  final String root;
  final String branch;

  GitSource({
    required this.user,
    required this.repository,
    this.root = 'Mods',
    this.branch = 'main',
  });

  String get uri => 'https://github.com/$user/$repository';
}
