import 'dart:io';

import 'package:bey_stats/services/logger.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class Datamanager {

  void downloadDatabase() async {
    DateTime now = DateTime.now();

    String fileTimeStamp = "${now.day}-${now.month}-${now.year}_${now.hour}-${now.minute}-${now.second}";
    Logger.debug("${(await getApplicationDocumentsDirectory()).listSync()}");


    File originalFile = File('${(await getApplicationDocumentsDirectory()).path}/bey_combat_logger.db');
    String newFilePath = '${(await getApplicationDocumentsDirectory()).path}/backup~$fileTimeStamp.beystats';
    await originalFile.copy(newFilePath);

    final result = await Share.shareXFiles([XFile(newFilePath)]);
    File newFile = File(newFilePath);
    await newFile.delete();

    if (result.status == ShareResultStatus.success) {
      Logger.info('Successfully backup database');
    }
  }

}