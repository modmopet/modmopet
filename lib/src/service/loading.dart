import 'package:flutter/foundation.dart';

class LoadingService extends ChangeNotifier {
  LoadingService._();
  String? text;
  static final instance = LoadingService._();

  Future<void> show(String message) async {
    text = message;
    notifyListeners();
  }

  Future<void> clear() async {
    text = null;
    notifyListeners();
  }
}
