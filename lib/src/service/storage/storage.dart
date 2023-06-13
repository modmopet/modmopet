/// A service that stores and retrieves data from a storage
interface class Storage {
  Future<T?> get<T>(String key) async {
    return null;
  }

  Future<void> set<T>(String key, T value) async {}
  Future<void> remove(String key) async {}
  Future<void> clear() async {}
}
