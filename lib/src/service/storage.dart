import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves data from a storage
class StorageService {
  static StorageService? _instance;
  static StorageService get instance => _instance!;

  // @89pleasure This one is from your temp version of the shared_preferences version of storage
  Future<SharedPreferences> get prefs async =>
      await SharedPreferences.getInstance();

  /// private constructor of StorageService
  ///
  /// This constructor is private because we don't want to allow the creation of multiple instances of StorageService
  StorageService._();

  /// factory of BasicStorageService
  static BasicLocalStorageService get basicStorageService {
    // if the instance is null, create a new one
    return BasicLocalStorageService._instance ??= BasicLocalStorageService._();
  }

  Future<T?> get<T>(String key) async {
    return null;
  }

  Future<void> set<T>(String key, T value) async {}
  Future<void> remove(String key) async {}
  Future<void> clear() async {}
}

/// A basic implementation of StorageService using shared_preferences
class BasicLocalStorageService implements StorageService {
  static BasicLocalStorageService? _instance;
  static BasicLocalStorageService get instance =>
      StorageService.basicStorageService;

  late SharedPreferences _storage;

  /// private constructor of BasicStorageService
  ///
  /// This constructor is private because we don't want to allow the creation of multiple instances of BasicStorageService
  BasicLocalStorageService._();

  Future<void> init() async {
    _storage = await SharedPreferences.getInstance();
  }

  /// get the value retrieved with a key from the storage
  ///
  /// This method will automatically convert the value to the correct type if the value is a String, int, double or bool
  @override
  Future<T?> get<T>(String key) async {
    await _storage.reload();
    switch (T) {
      case String:
        return _storage.getString(key) as T?;
      case int:
        return _storage.getInt(key) as T?;
      case double:
        return _storage.getDouble(key) as T?;
      case bool:
        return _storage.getBool(key) as T?;
      default:
        return jsonDecode(_storage.getString(key)!) as T?;
    }
  }

  /// set a value with a key in the storage
  ///
  /// This method will automatically convert the value to a json string if the value is not a String, int, double or bool
  @override
  Future<void> set<T>(String key, T value) async {
    switch (T) {
      case String:
        _storage.setString(key, value as String);
        break;
      case int:
        _storage.setInt(key, value as int);
        break;
      case double:
        _storage.setDouble(key, value as double);
        break;
      case bool:
        _storage.setBool(key, value as bool);
        break;
      default:
        _storage.setString(key, jsonEncode(value));
        break;
    }
  }

  /// remove a value with a key from the storage
  ///
  /// This method will do nothing if the key doesn't exist
  @override
  Future<void> remove(String key) async {
    _storage.remove(key);
  }

  /// clear all values from the storage
  ///
  /// This method will do nothing if the storage is already empty
  @override
  Future<void> clear() async {
    _storage.clear();
  }
}

/// A secure implementation of StorageService using flutter_secure_storage
// class SecureLocalStorageService implements StorageService {
//   static final SecureLocalStorageService _instance = SecureLocalStorageService();
//   static SecureLocalStorageService get instance => _instance;

//   FlutterSecureStorage _storage;

//   SecureLocalStorageService();

//   Future<void> init() async {
//     AndroidOptions _getAndroidOptions() => const AndroidOptions(
//       encryptedSharedPreferences: true,
//     );
//     _storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
//   }

//   @override
//   Future<T?> get<T>(String key) async {
//     switch (T) {
//       case String:
//         return await _storage.read(key: key) as T?;
//       case int:
//         return int.tryParse(await _storage.read(key: key) ?? '') as T?;
//       case double:
//         return double.tryParse(await _storage.read(key: key) ?? '') as T?;
//       case bool:
//         return (await _storage.read(key: key) == 'true') as T?;
//       default:
//         return jsonDecode(await _storage.read(key: key) ?? '') as T?;
//     }
//   }

//   @override
//   Future<void> set<T>(String key, T value) async {
//     switch (T) {
//       case String:
//         return await _storage.write(key: key, value: value);
//       case int:
//         return await _storage.write(key: key, value: value);
//       case double:
//         return await _storage.write(key: key, value: value);
//       case bool:
//         return await _storage.write(key: key, value: value);
//       default:
//         return await _storage.write(key: key, value: jsonEncode(value));
//     }
//   }

//   @override
//   Future<void> remove(String key) async {
//     _storage.delete(key: key);
//   }

//   @override
//   Future<void> clear() async {
//     _storage.deleteAll();
//   }

// }
