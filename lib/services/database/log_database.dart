import 'package:bey_stats/structs/log_object.dart';
import 'database_core.dart';

class LogDatabase {
  DatabaseCore? _database;
  LogDatabase._(this._database);

  static LogDatabase? _donationInstance;

  static Future<LogDatabase> getInstance() async {
     _donationInstance ??= LogDatabase._(await DatabaseCore.getInstance());
    return _donationInstance!;
  }

  Future<void> writeLog(LogObject log) async {
    try {
    await (await _database!.connection()).execute(
        "INSERT INTO 'logs' ('log_time', 'log_type', 'log_message') VALUES (\"${log.getDateTimeString()}\",\"${log.getType()}\", \"${log.getMessage()}\");");
    } catch (e) {
      // THis is Intenstion Left Blank
    }
  }

  Future<void> clearLogs() async {
    await (await _database!.connection()).execute("DROP TABLE 'logs';");
    await (await _database!.connection()).execute(
        "CREATE TABLE IF NOT EXISTS 'logs' (id INTEGER PRIMARY KEY, log_time datetime default current_timestamp, log_type TEXT, log_message TEXT);");
  }

  Future<List<LogObject>> getLogs() async {
    var result = await (await _database!.connection()).rawQuery("SELECT * FROM 'logs';");
    return result.map((log) {
      return LogObject.time(
          log['log_type'] as String,
          log['log_message'] as String,
          DateTime.parse(log['log_time'] as String));
    }).toList();
  }
}
