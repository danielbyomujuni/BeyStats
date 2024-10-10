import 'dart:io';

import 'package:bey_stats/services/database/database_core.dart';
import 'package:bey_stats/services/database/launches_database.dart';
import 'package:bey_stats/services/logger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class Datamanager {
  void downloadDatabase() async {
    DateTime now = DateTime.now();

    String fileTimeStamp =
        "${now.day}-${now.month}-${now.year}_${now.hour}-${now.minute}-${now.second}";
    Logger.debug("${(await getApplicationDocumentsDirectory()).listSync()}");

    File originalFile = File(
        '${(await getApplicationDocumentsDirectory()).path}/bey_combat_logger.db');
    String newFilePath =
        '${(await getApplicationDocumentsDirectory()).path}/backup~$fileTimeStamp.beystats';
    await originalFile.copy(newFilePath);
    File newFile = File(newFilePath);
    final result = await Share.shareXFiles([XFile(newFilePath)]);
    await newFile.delete();

    if (result.status == ShareResultStatus.success) {
      Logger.info('Successfully backup database');
    }
  }

  Future<void> getNewDatabase() async {
    File oldTmpFile =
        File("${(await getApplicationDocumentsDirectory()).path}/tmp.beystats");
    if (oldTmpFile.existsSync()) {
      oldTmpFile.deleteSync();
    }

    Logger.debug(
        "STUFF:${(await getApplicationDocumentsDirectory()).listSync()}");

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowCompression: false,
      type: FileType.any,
    );

    if (result == null) {
      return;
    }

    if (!result.files.single.extension!.endsWith("beystats")) {
      Logger.debug("${result.files.single.extension!.endsWith("beystats")}");
      throw Error();
    }

    String path = result.files.single.path!;

    bool isValid = await DatabaseCore.verifyDatabaseFile(path);

    if (!isValid) {
      Logger.error("Database File is Bad");
      throw Error();
    }

    File(path).copySync(
        "${(await getApplicationDocumentsDirectory()).path}/tmp.beystats");
  }

  Future<void> saveNewDatabase() async {
    File tmpFile =
        File("${(await getApplicationDocumentsDirectory()).path}/tmp.beystats");
    if (!tmpFile.existsSync()) {
      return;
    }

    Directory dir = await getApplicationDocumentsDirectory();

    Logger.debug(dir.listSync().toString());

    DatabaseCore core = await DatabaseCore.getInstance();
    DatabaseCore.lock();
    await core.close();
    Logger.debug("Database Closed");
    File oldDbFile = File(
        "${(await getApplicationDocumentsDirectory()).path}/bey_combat_logger.db");
    if (oldDbFile.existsSync()) {
      oldDbFile.deleteSync();
    }
    await tmpFile.copy(
        "${(await getApplicationDocumentsDirectory()).path}/bey_combat_logger.db");
    //Logger.debug("Create new Database");
    DatabaseCore.unlock();
    final _ = await (await LaunchesDatabase.getInstance()).signal();
    //Logger.debug("Inited Database");

    //Logger.debug("Done");
  }

  Future<void> recoverAndroidDB() async {
    if (Platform.isAndroid) {
      File oldDbFile = File(
          "/data/data/com.nekosyndicate.bey_stats/databases/bey_combat_logger.db");
      if (oldDbFile.existsSync()) {
        File("${(await getApplicationDocumentsDirectory()).path}/bey_combat_logger.db")
            .deleteSync();
        oldDbFile.copySync(
            "${(await getApplicationDocumentsDirectory()).path}/bey_combat_logger.db");
        oldDbFile.deleteSync();
      }
    }
  }
}
