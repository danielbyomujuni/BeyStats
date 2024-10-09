import 'database_core.dart';

class ExperimentsDatabase {

  DatabaseCore? _database;
  ExperimentsDatabase._(this._database);

  static ExperimentsDatabase? _donationInstance;

  static Future<ExperimentsDatabase> getInstance() async {
    _donationInstance ??= ExperimentsDatabase._(await DatabaseCore.getInstance());
    return _donationInstance!;
  }

  Future<Map<String, bool>> getExperiments() async {
    var result = await (await _database!.connection()).rawQuery("SELECT * FROM 'experiments_status';");
    return {
      for (var entry in result)
        entry['experiment_id'] as String: entry['is_enabled'] as int == 1
    };
  }

  Future<void> setExperiment(String experimentId, bool value) async {
    await (await _database!.connection()).execute(
        "INSERT INTO experiments_status(experiment_id, is_enabled) VALUES(?, ?) ON CONFLICT(experiment_id) DO UPDATE SET is_enabled = ? WHERE experiment_id = ?;",
        [experimentId, value ? 1 : 0, experimentId, value ? 1 : 0]);
  }
}
