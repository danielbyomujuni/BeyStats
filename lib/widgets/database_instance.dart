import 'package:bey_stats/battlepass/database_observer.dart';
import 'package:bey_stats/structs/launch_data.dart';
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
        "SELECT launch_power, session_number,launch_date FROM 'standard_launches';");

    var launches = result.map((res) {
      return LaunchData(
          res["session_number"] as int,
          res["launch_power"] as int,
          DateTime.parse(res["launch_date"] as String));
    });
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
        "SELECT launch_power, session_number,launch_date FROM 'standard_launches' ORDER BY launch_power DESC LIMIT 5;");

    if (result.isEmpty) {
      return [];
    }

    var launches = result.map((res) {
      return LaunchData(
          res["session_number"] as int,
          res["launch_power"] as int,
          DateTime.parse(res["launch_date"] as String));
    });
    return launches.toList();
  }

  Future<void> clearDatabase() async {
    await _database.execute("DROP TABLE 'standard_launches';");
    await _database.execute(
        "CREATE TABLE IF NOT EXISTS 'standard_launches' (id INTEGER PRIMARY KEY,session_number INTEGER, launch_power INTEGER, launch_date datetime default current_timestamp);");

    //await _database.execute(
    //    "UPDATE SQLITE_SEQUENCE SET seq = 0 WHERE name = 'standard_launches';");
  }
}
