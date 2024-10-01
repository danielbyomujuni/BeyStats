import 'database_core.dart';

class ExperimentsDatabase extends DatabaseCore {
  ExperimentsDatabase._(super.database) : super.connect();

  static Future<ExperimentsDatabase> getInstance() async {
    DatabaseCore core = await DatabaseCore.getInstance();
    return ExperimentsDatabase._(core.database);
  }

  Future<Map<String, bool>> getExperiments() async {
    var result = await database.rawQuery("SELECT * FROM 'experiments_status';");
    return {
      for (var entry in result)
        entry['experiment_id'] as String: entry['is_enabled'] as int == 1
    };
  }

  Future<void> setExperiment(String experimentId, bool value) async {
    await database.execute(
        "INSERT INTO experiments_status(experiment_id, is_enabled) VALUES(?, ?) ON CONFLICT(experiment_id) DO UPDATE SET is_enabled = ? WHERE experiment_id = ?;",
        [experimentId, value ? 1 : 0, experimentId, value ? 1 : 0]);
  }
}
