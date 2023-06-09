// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

void main() {
  final pem = File('./key.pem');
  final buff = pem.readAsBytesSync();
  final base64 = base64Encode(buff);

  print('Generated base64 output:');
  print(base64);
}
