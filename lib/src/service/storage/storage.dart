/// A service that stores and retrieves data from a storage
class Storage {
  static Storage? _instance;
  static Storage get instance => _instance!;

  /// private constructor of StorageService
  ///
  /// This constructor is private because we don't want to allow the creation of multiple instances of StorageService
  Storage._();

  Future<T?> get<T>(String key) async {
    return null;
  }

  Future<void> set<T>(String key, T value) async {}
  Future<void> remove(String key) async {}
  Future<void> clear() async {}
}
