import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class MxLog {
  static Map<String, dynamic> parseJson(data) {
    return Map<String, dynamic>.from(data);
  }

  static List<Map<String, dynamic>> parseJsonList(data) {
    return List<Map<String, dynamic>>.from(data);
  }

  static const String _yellow = "\x1B[33m";
  static const String _blue = "\x1B[34m";
  static const String _reset = "\x1B[0m";

  static info(String msg, {String? name}) {
    if (kDebugMode) {
      developer.log(
        "$_blue${name != null ? '[$name]' : ''} $msg$_reset",
        name: "INFO",
      );
    }
  }

  static error(String msg, {String? name}) {
    if (kDebugMode) {
      developer.log(
        "$_yellow${name != null ? '[$name]' : ''} $msg$_reset",
        name: "ERROR",
      );
    }
  }
}
