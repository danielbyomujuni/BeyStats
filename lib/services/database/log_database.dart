import 'package:bey_stats/structs/log_object.dart';
import 'database_core.dart';

class LogDatabase extends DatabaseCore {
  LogDatabase._(super.database) : super.connect();

  static Future<LogDatabase> getInstance() async {
    DatabaseCore core = await DatabaseCore.getInstance();
    return LogDatabase._(core.database);
  }

  Future<void> writeLog(LogObject log) async {
    await database.execute(
        "INSERT INTO 'logs' ('log_time', 'log_type', 'log_message') VALUES (\"${log.getDateTimeString()}\",\"${log.getType()}\", \"${log.getMessage()}\")");
  }

  Future<void> clearLogs() async {
    await database.execute("DROP TABLE 'logs';");
    await database.execute(
        "CREATE TABLE IF NOT EXISTS 'logs' (id INTEGER PRIMARY KEY, log_time datetime default current_timestamp, log_type TEXT, log_message TEXT);");
  }

  Future<List<LogObject>> getLogs() async {
    var result = await database.rawQuery("SELECT * FROM 'logs';");
    return result.map((log) {
      return LogObject.time(
          log['log_type'] as String,
          log['log_message'] as String,
          DateTime.parse(log['log_time'] as String));
    }).toList();
  }
}
