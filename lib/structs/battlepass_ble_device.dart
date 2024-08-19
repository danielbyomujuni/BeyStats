
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BattlepassBleDevice {
  late final BluetoothDevice? device;
  late final String address;
  late final String name;
  late final int rssi;


  BattlepassBleDevice({this.device, required this.address, required this.name});

  BattlepassBleDevice.fromBluetooth(BluetoothDevice this.device) {
    address = device!.remoteId.str;
    name = device!.platformName;
    rssi = -1;
  }

  BattlepassBleDevice.fromScanResult(ScanResult scanResult) {
    device = scanResult.device;
    address = device!.remoteId.str;
    name = device!.platformName;
    rssi = scanResult.rssi;
  }
}