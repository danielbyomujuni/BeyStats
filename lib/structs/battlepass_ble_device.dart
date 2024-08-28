import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BattlepassBleDevice {
  late final BluetoothDevice? device;
  late final String address;
  late final String name;
  late final int rssi;
  late final String battlepassID;

  BattlepassBleDevice(
      {this.device, required this.address, required this.name}) {
    var bytes = utf8.encode(address);
    var digest = sha256.convert(bytes);
    battlepassID = digest.toString().substring(0, 5);
  }

  BattlepassBleDevice.fromBluetooth(BluetoothDevice this.device) {
    address = device!.remoteId.str; //mac_addres
    name = device!.platformName;
    rssi = -1;

    var bytes = utf8.encode(address);
    var digest = sha256.convert(bytes);
    battlepassID = digest.toString().substring(0, 5);
  }

  BattlepassBleDevice.fromScanResult(ScanResult scanResult) {
    device = scanResult.device;
    address = device!.remoteId.str;
    name = device!.platformName;
    rssi = scanResult.rssi;

    var bytes = utf8.encode(address);
    var digest = sha256.convert(bytes);
    battlepassID = digest.toString().substring(0, 5);
  }
}
