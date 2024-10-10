import 'dart:async';
import 'dart:io';

//import 'package:bey_stats/services/logger.dart';
import 'package:bey_stats/services/datamanager.dart';
import 'package:bey_stats/services/logger.dart';
import 'package:bey_stats/services/semaphore.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:path/path.dart' as p;
//import 'package:path_provider/path_provider.dart';

class DatabaseCore {
  // ignore: non_constant_identifier_names
  static final TABLES = [
    "standard_launches",
    "logs",
    "experiments_status",
    "donations"
  ];


  static DatabaseCore? _instance;
  static Future<DatabaseCore>? _instanceFuture;

  static Semaphore flag = Semaphore(1);
  static bool lockDatabase = false;
  late Database? _database;

  @protected
  DatabaseCore.connect(Database database) {_database = database;}

  static Future<DatabaseCore> getInstance() async {
    await flag.acquire();
  
    if (_instance != null) {
      flag.release();
      print("Instance: $_instance");
      return _instance!;
    }

    if (_instanceFuture != null) {
      print("Future: $_instanceFuture");
      flag.release();
      return _instanceFuture!;
    }

    _instanceFuture = _createInstance();
    flag.release();
    return _instanceFuture!;
  }

  static Future<DatabaseCore> _createInstance() async {
      await Datamanager().recoverAndroidDB();

      print("Creating Instance");
      var db = await openDatabase(
          '${(await getApplicationDocumentsDirectory()).path}/bey_combat_logger.db');
      await _createTables(db);
      _instance = DatabaseCore.connect(db);
      
      _instanceFuture = null; // Clear the future
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
    await db.execute(
        "CREATE TABLE IF NOT EXISTS 'donations' (id INTEGER PRIMARY KEY, purchase_time datetime default current_timestamp, donation_amount REAL NOT NULL);");
  }

  Future<void> clearTables() async {
    await database.execute("""
        DROP TABLE IF EXISTS 'standard_launches'; 
        DROP TABLE IF EXISTS 'logs'; 
        DROP TABLE IF EXISTS 'experiments_status'; 
        DROP TABLE IF EXISTS 'donations'; 
        """);
    await _createTables(database);
  }

  @protected
  Database get database => _database!;

  static Future<bool> verifyDatabaseFile(String path) async {
    final header = await File(path).openRead(0, 16).first;
    const sqliteSignature = "SQLite format 3";
    if (!String.fromCharCodes(header).startsWith(sqliteSignature)) {
      return false;
    }

    try {
      Database db = await openDatabase(path);

      final tables = await db
          .rawQuery("SELECT name FROM sqlite_master WHERE type='table';");
      Logger.debug("${tables}");
      List<String> tableNames =
          tables.map((entries) => entries["name"] as String).toList();

      final disjointTables = _xorStringArrays(tableNames, TABLES);
      await db.close();

      return disjointTables.isEmpty;
    } catch (e) {
      return false;
    }
  }

  static List<String> _xorStringArrays(
      List<String> array1, List<String> array2) {
    // Create a set for each array to make lookups faster
    Set<String> set1 = array1.toSet();
    Set<String> set2 = array2.toSet();

    // XOR result: values that are only in one of the sets
    Set<String> result = set1.difference(set2).union(set2.difference(set1));

    // Convert the result set back to a list
    return result.toList();
  }

  Future<Database> connection() async {
    while (_instance == null) {
      await DatabaseCore.getInstance();
    }

    
    return _instance!._database!;
  }
  

  Future<void> close() async {
    _database!.close();
    _database = null;
    _instance = null;
    _instanceFuture = null;
  }

  static Future<void> lock() async {
    await flag.acquire();
  }

  static void unlock() {
    flag.release();
  }
}
