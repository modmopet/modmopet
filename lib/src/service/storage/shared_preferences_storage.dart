import 'dart:convert';

import 'package:modmopet/src/service/storage/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesStorage implements Storage {
  static SharedPreferencesStorage? _instance;
  static SharedPreferencesStorage get instance => _instance!;

  late SharedPreferences _storage;

  /// private constructor of BasicStorageService
  ///
  /// This constructor is private because we don't want to allow the creation of multiple instances of BasicStorageService
  SharedPreferencesStorage._();

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
