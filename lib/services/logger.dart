

import 'dart:developer';

import 'package:bey_stats/services/database/log_database.dart';
import 'package:bey_stats/structs/log_object.dart';
import 'package:flutter/foundation.dart';

class Logger {
  static void info(String msg) {
    _internalLog(LogObject("INFO", msg));
  }
  static void error(String msg) {
    _internalLog(LogObject("ERR", msg));
  }

  static void debug(String msg) {
    if (kDebugMode) {
      _internalLog(LogObject("DEBUG", msg));
    }
  }

  static void _internalLog(LogObject logObject) {
    LogDatabase.getInstance().then((db) {
      db.writeLog(logObject);
    });
    log(logObject.toString());
    if (kDebugMode) { print(logObject.toString()); }
  }
}