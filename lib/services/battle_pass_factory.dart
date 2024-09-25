import 'dart:async';

import 'package:bey_stats/services/battle_pass.dart';
import 'package:bey_stats/services/logger.dart';
import 'package:bey_stats/structs/battlepass_ble_device.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

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
    try {
      Logger.info("Scanning for Battlepass");

      FlutterBluePlus.onScanResults.listen(
        (results) async {
          if (results.isNotEmpty) {
            ScanResult r = results.last;
            currentList.add(BattlepassBleDevice.fromScanResult(r));
            battlepassStream.add(currentList);

            Logger.info(
                '${r.device.remoteId}: "${r.advertisementData.advName}" found!');
          }
        },
        onError: (e) => Logger.error(e.toString()),
      );
      await FlutterBluePlus.adapterState
          .where((val) => val == BluetoothAdapterState.on)
          .first;
      await FlutterBluePlus.startScan(withNames: ["BEYBLADE_TOOL01"]);
      Logger.info("Scanning Complete");
    } catch (err) {
      Logger.error("Scanning Error");
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
