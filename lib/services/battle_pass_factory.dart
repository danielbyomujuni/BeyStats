import 'dart:async';

import 'package:bey_stats/services/battle_pass.dart';
import 'package:bey_stats/structs/battlepass_ble_device.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:logger/logger.dart';

abstract class AbstractBattlePassFactory extends GetxController {
  Future<void> scanForBattlePass();
  Future<void> endScanForBattlePass();
  Future<void> connectToBattlePass(BattlepassBleDevice device);
  Stream<List<BattlepassBleDevice>> getScanBattlePassResults();
  List<BattlepassBleDevice> currentList = [];
}

class BattlePassFactory extends AbstractBattlePassFactory {
  static StreamController<List<BattlepassBleDevice>> battlepassStream =
      StreamController<List<BattlepassBleDevice>>.broadcast();

  @override
  Future<void> scanForBattlePass() async {
    FlutterBluePlus.setLogLevel(LogLevel.verbose);
    var logger = Logger();
    try {
      logger.i("Scanning");

      FlutterBluePlus.onScanResults.listen(
        (results) async {
          if (results.isNotEmpty) {
            ScanResult r = results.last;
            currentList.add(BattlepassBleDevice.fromScanResult(r));
            battlepassStream.add(currentList);

            logger.i(
                '${r.device.remoteId}: "${r.advertisementData.advName}" found!');
          }
        },
        onError: (e) => logger.e(e),
      );
      await FlutterBluePlus.adapterState
          .where((val) => val == BluetoothAdapterState.on)
          .first;
      await FlutterBluePlus.startScan(withNames: ["BEYBLADE_TOOL01"]);
      logger.i("Scanning done");
    } catch (err) {
      logger.i("Scanning Error");
      rethrow;
    }
  }

  @override
  Future<void> endScanForBattlePass() async {
    await FlutterBluePlus.stopScan();
  }

  @override
  Stream<List<BattlepassBleDevice>> getScanBattlePassResults() =>
      battlepassStream.stream.asBroadcastStream();

  @override
  Future<void> connectToBattlePass(BattlepassBleDevice device) async {
    await BattlePass.connectToBattlePass(device);
  }
}
