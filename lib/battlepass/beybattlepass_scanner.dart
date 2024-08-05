import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class BeyBattlePassScanner extends GetxController {
  Future scanForBattlePass() async {
    try {
      print("scanning");

      await FlutterBluePlus.adapterState
          .where((val) => val == BluetoothAdapterState.on)
          .first;
      await FlutterBluePlus.startScan(
          withNames: ["BEYBLADE_TOOL01"], timeout: const Duration(seconds: 10));
      print("scanning done");
    } catch (err) {
      print("Scanning Error");
    }
  }

  Stream<List<ScanResult>> get scanResult => FlutterBluePlus.scanResults;
}
