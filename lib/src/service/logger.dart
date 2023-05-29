import 'package:flutter/material.dart';

class LoggerService extends ChangeNotifier {
  LoggerService._();
  List<String> messages = [];
  static final instance = LoggerService._();

  Future<void> log(String message) async {
    messages.add(message);
    notifyListeners();
  }
}
