import 'dart:math';

import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseInstance {
  static DatabaseInstance? _instance;
  Database _database;

  DatabaseInstance._(Database this._database);

  static Future<DatabaseInstance> getInstance() async {
    if (_instance == null) {
      var db = await openDatabase('bey_combat_logger.db');

      //create the tables
      await db.execute(
          "CREATE TABLE IF NOT EXISTS 'standard_launches' (id INTEGER PRIMARY KEY, launch_power INTEGER, launch_date datetime default current_timestamp);");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS 'general' (id TEXT PRIMARY KEY, value INTEGER);");
      await db.execute(
          "INSERT OR IGNORE INTO 'general' ('id', 'value') VALUES ('ALL_TIME_MAX', 0)");
      await db.execute(
          "INSERT OR IGNORE INTO 'general' ('id', 'value') VALUES ('SESSION_MAX', 0)");

      _instance = DatabaseInstance._(db);
    }
    return _instance!;
  }

  Future<void> saveLaunches(List<int> launches) async {
    if (launches.isEmpty) {
      return;
    }
    var query = "INSERT INTO 'standard_launches' ('launch_power') VALUES";
    for (int launch in launches) {
      query += "(${launch}),";
    }

    query = query.substring(0, query.length - 1);
    query += ";";

    await _database.execute(query);

    var max_launch = launches.reduce(max);
    await _database.execute(
        "UPDATE 'general' SET value = ${max_launch} WHERE id = 'SESSION_MAX';");
    await _database.execute(
        "UPDATE 'general' SET value = MAX(value, ${max_launch}) WHERE id = 'ALL_TIME_MAX';");
  }

  Future<List<int>> getLaunches() async {
    var result = await _database
        .rawQuery("SELECT launch_power FROM 'standard_launches';");
    var launches = result.map((launch) {
      return launch["launch_power"] as int;
    });
    return launches.toList();
  }

  Future<int> getAllTimeMax() async {
    var result = await _database
        .rawQuery("SELECT value FROM 'general' where id = 'ALL_TIME_MAX';");
    return result[0]["value"] as int;
  }

  Future<int> getSessionTimeMax() async {
    var result = await _database
        .rawQuery("SELECT value FROM 'general' where id = 'SESSION_MAX';");
    return result[0]["value"] as int;
  }

  Future<void> clearDatabase() async {
    await _database.execute("Delete from 'standard_launches';");
    await _database.execute("Delete from 'general';");
    await _database.execute(
        "INSERT OR IGNORE INTO 'general' ('id', 'value') VALUES ('ALL_TIME_MAX', 0)");
    await _database.execute(
        "INSERT OR IGNORE INTO 'general' ('id', 'value') VALUES ('SESSION_MAX', 0)");
    //await _database.execute(
    //    "UPDATE SQLITE_SEQUENCE SET seq = 0 WHERE name = 'standard_launches';");
  }
}
