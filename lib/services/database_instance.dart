import 'package:bey_stats/battlepass/database_observer.dart';
import 'package:bey_stats/structs/launch_data.dart';
import 'package:bey_stats/structs/log_object.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseInstance {
  static DatabaseInstance? _instance;
  final Database _database;

  DatabaseInstance._(this._database);

  static Future<DatabaseInstance> getInstance() async {
    if (_instance == null) {
      var db = await openDatabase('bey_combat_logger.db');

      //create the tables
      await db.execute(
          "CREATE TABLE IF NOT EXISTS 'standard_launches' (id INTEGER PRIMARY KEY,session_number INTEGER, launch_power INTEGER, launch_date datetime default current_timestamp);");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS 'logs' (id INTEGER PRIMARY KEY, log_time datetime default current_timestamp, log_type TEXT, log_message TEXT);");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS 'experiments_status' (experiment_id TEXT NOT NULL PRIMARY KEY, is_enabled INT DEFAULT 0 NOT NULL);");

      _instance = DatabaseInstance._(db);
    }
    return _instance!;
  }

  Future<void> saveLaunches(List<int> launches) async {
    if (launches.isEmpty) {
      return;
    }
    var query =
        "INSERT INTO 'standard_launches' ('launch_power', 'session_number') VALUES";
    for (int launch in launches) {
      query +=
          "($launch, (SELECT coalesce(MAX(session_number), -1) FROM standard_launches) + 1),";
    }

    query = query.substring(0, query.length - 1);
    query += ";";
    await _database.execute(query);

    final obs = DatabaseObserver();
    obs.updateMaxValues();
  }

  Future<List<int>> getLaunches() async {
    var result = await _database
        .rawQuery("SELECT launch_power FROM 'standard_launches';");
    var launches = result.map((launch) {
      return launch["launch_power"] as int;
    });
    return launches.toList();
  }

  Future<List<LaunchData>> getLaunchData() async {
    var result = await _database.rawQuery(
        "SELECT id, launch_power, session_number,launch_date FROM 'standard_launches' ORDER BY id DESC;");

    var launches = result.map((res) {
      return LaunchData(
          res["id"] as int,
          res["session_number"] as int,
          res["launch_power"] as int,
          DateTime.parse(res["launch_date"] as String));
    });

    //print(launches.map((e) => "${e.id}:${e.launchPower}").toList());
    return launches.toList();
  }

  Future<int> getAllTimeMax() async {
    var result = await _database.rawQuery(
        "select coalesce(max(launch_power),0) as value FROM standard_launches;");
    if (result.isEmpty ||
        result[0]["value"] == Null ||
        result[0]["value"] == null) {
      return 0;
    }

    return result[0]["value"] as int;
  }

  Future<int> getSessionTimeMax() async {
    var result = await _database.rawQuery(
        "select coalesce(max(launch_power),0) as value  FROM standard_launches WHERE session_number = (SELECT max(session_number) FROM standard_launches);");
    if (result.isEmpty ||
        result[0]["value"] == Null ||
        result[0]["value"] == null) {
      return 0;
    }

    return result[0]["value"] as int;
  }

  Future<int> getSessionCount() async {
    var result = await _database.rawQuery(
        "SELECT max(session_number) as value FROM standard_launches;");

    if (result.isEmpty ||
        result[0]["value"] == Null ||
        result[0]["value"] == null) {
      return 0;
    }

    return (result[0]["value"] as int) + 1;
  }

  Future<int> getLaunchCount() async {
    var result = await _database
        .rawQuery("SELECT count(*) as value FROM standard_launches;");
    if (result.isEmpty ||
        result[0]["value"] == Null ||
        result[0]["value"] == null) {
      return 0;
    }
    return result[0]["value"] as int;
  }

  Future<List<LaunchData>> getTopFive() async {
    var result = await _database.rawQuery(
        "SELECT id, launch_power, session_number,launch_date FROM 'standard_launches' ORDER BY launch_power DESC LIMIT 5;");

    if (result.isEmpty) {
      return [];
    }

    var launches = result.map((res) {
      return LaunchData(
          res["id"] as int,
          res["session_number"] as int,
          res["launch_power"] as int,
          DateTime.parse(res["launch_date"] as String));
    });
    return launches.toList();
  }

  Future<void> writeLog(LogObject log) async {
    await _database.execute(
        "INSERT INTO 'logs' ('log_time', 'log_type', 'log_message') VALUES (\"${log.getDateTimeString()}\",\"${log.getType()}\", \"${log.getMessage()}\")");
  }

  Future<void> clearLogs() async {
    await _database.execute("DROP TABLE 'logs';");
    await _database.execute(
        "CREATE TABLE IF NOT EXISTS 'logs' (id INTEGER PRIMARY KEY, log_time datetime default current_timestamp, log_type TEXT, log_message TEXT);");
  }

  Future<List<LogObject>> getLogs() async {
    var result = await _database.rawQuery("SELECT * FROM 'logs';");
    var logs = result.map((log) {
      return LogObject.time(
          log['log_type'] as String,
          log['log_message'] as String,
          DateTime.parse(log['log_time'] as String));
    });
    return logs.toList();
  }

  Future<Map<String, bool>> getExperiments() async {
    var result =
        await _database.rawQuery("SELECT * FROM 'experiments_status';");
    Map<String, bool> experimentsMap = {
      for (var entry in result)
        entry['experiment_id'] as String: entry['is_enabled'] as int == 1
    };
    return experimentsMap;
  }

  Future<void> setExperiment(String experimentId, bool value) async {
    await _database.execute(
        "INSERT INTO experiments_status(experiment_id, is_enabled) VALUES(?, ?) ON CONFLICT(experiment_id) DO UPDATE SET is_enabled = ? WHERE experiment_id = ?;",
          [experimentId, value ? 1 : 0, experimentId, value ? 1 : 0]
        );
  }



  Future<void> clearDatabase() async {
    await _database.execute("DROP TABLE 'standard_launches';");
    await _database.execute(
        "CREATE TABLE IF NOT EXISTS 'standard_launches' (id INTEGER PRIMARY KEY,session_number INTEGER, launch_power INTEGER, launch_date datetime default current_timestamp);");
    await clearLogs();
  }

  Future<void> deleteLaunchData(LaunchData launch) async {
    await _database
        .execute("DELETE FROM 'standard_launches' WHERE id = ${launch.id};");

    final obs = DatabaseObserver();
    obs.updateMaxValues();
  }
}
