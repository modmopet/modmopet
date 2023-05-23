class Mod {
  final String _id;
  final String _title;
  final int _category;
  final dynamic _version;
  final Map<dynamic, dynamic> _game;

  final String? subtitle;
  final String? description;
  final Map<dynamic, dynamic>? author;

  const Mod(
    this._id,
    this._title,
    this._category,
    this._version,
    this._game, {
    this.subtitle,
    this.description,
    this.author,
  });

  String get id => _id;
  String get title => _title;
  int get category => _category;
  String get version => _version != null ? _version.toString() : '0.0.0';
  Map<dynamic, dynamic> get game => _game;
}

enum ModType {
  general,
  graphic,
  performance,
  teak,
}
