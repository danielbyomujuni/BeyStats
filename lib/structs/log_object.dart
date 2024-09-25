

import 'package:intl/intl.dart';

class LogObject {
  final String _type; //Info
  final String _message;
  late final DateTime _time;

  LogObject(this._type, this._message) {
    _time = DateTime.now();
  }
  LogObject.time(this._type, this._message, this._time);

  String getType() {
    return _type;
  }

  String getMessage() {
    return _message;
  }

  String getDateTimeString() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(_time);
  }

  @override
  String toString() {
    return "[$_type][${getDateTimeString()}]: $_message";
  }
}