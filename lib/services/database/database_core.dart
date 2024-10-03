import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseCore {
  static DatabaseCore? _instance;
  late final Database _database;

  @protected
  DatabaseCore.connect(this._database);

  static Future<DatabaseCore> getInstance() async {
    if (_instance == null) {
      var db = await openDatabase('bey_combat_logger.db');
      await _createTables(db);
      _instance = DatabaseCore.connect(db);
    }
    return _instance!;
  }

  static void setInstance(DatabaseCore newDatabase) {
    _instance = newDatabase;
  }

  static Future<void> _createTables(Database db) async {
    await db.execute(
        "CREATE TABLE IF NOT EXISTS 'standard_launches' (id INTEGER PRIMARY KEY, session_number INTEGER, launch_power INTEGER, launch_date datetime default current_timestamp);");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS 'logs' (id INTEGER PRIMARY KEY, log_time datetime default current_timestamp, log_type TEXT, log_message TEXT);");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS 'experiments_status' (experiment_id TEXT NOT NULL PRIMARY KEY, is_enabled INT DEFAULT 0 NOT NULL);");
  }

  Future<void> clearTables() async {
     await database.execute("""
        DROP TABLE IF EXISTS 'standard_launches'; 
        DROP TABLE IF EXISTS 'logs'; 
        DROP TABLE IF EXISTS 'experiments_status'; 
        """);
    await _createTables(database);
  }

  @protected
  Database get database => _database;
}
