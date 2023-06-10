import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService._();
  static final instance = StorageService._();

  Future<SharedPreferences> get prefs async => await SharedPreferences.getInstance();
}
