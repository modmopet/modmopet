import 'package:flutter/material.dart';

class LoggerService extends ChangeNotifier {
  LoggerService._();
  List<String> messages = [];
  static final instance = LoggerService._();

  void log(String message) {
    messages.add(message);
    notifyListeners();
  }
}
