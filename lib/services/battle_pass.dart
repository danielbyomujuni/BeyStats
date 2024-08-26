import 'dart:async';

import 'package:bey_stats/battlepass/battlepass_models.dart';
import 'package:bey_stats/battlepass/battlepass_utils.dart';
import 'package:bey_stats/structs/battlepass_ble_device.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class AbstractBattlePass {
  Future<BattlePassHeader?> getHeaderFromBattlePass();
  Future<BattlePassLaunchData?> getLaunchDataFromBattlePass();
  Future<void> clearBattlePassData();
  Future<void> disconnectFromBattlePass();
}

class BattlePass extends AbstractBattlePass {
  static const headerByte = 0x51;
  static const getDataByte = 0x74;
  static const clearDataByte = 0x75;

  static BluetoothDevice? battlepassDevice;
  static BluetoothCharacteristic? readCharacteristic;
  static BluetoothCharacteristic? writeCharacteristic;

  static List<String> readBuffer = [];
  static Completer<void> readLock = Completer<void>();

  static Future<void> connectToBattlePass(
      BattlepassBleDevice battlepass) async {
    BattlePass.battlepassDevice = battlepass.device;
    if (BattlePass.battlepassDevice != null) {
      await BattlePass.battlepassDevice!.connect();

      List<BluetoothService> services =
          await BattlePass.battlepassDevice!.discoverServices();

      var mainService = services[0];
      if (services[0].uuid.str.startsWith("00001")) {
        mainService = services[1];
      }

      BattlePass.readCharacteristic = mainService.characteristics[1];
      BattlePass.writeCharacteristic = mainService.characteristics[0];

      final subscription =
          BattlePass.readCharacteristic!.onValueReceived.listen((value) {
        //print(convertIntListToHexString(value));
        readBuffer.add(convertIntListToHexString(value));
      });

      await BattlePass.readCharacteristic!.setNotifyValue(true);
      BattlePass.battlepassDevice!.cancelWhenDisconnected(subscription);
    }
  }

  @override
  Future<void> disconnectFromBattlePass() async {
    if (BattlePass.battlepassDevice != null) {
      await BattlePass.readCharacteristic!.setNotifyValue(false);
      await BattlePass.battlepassDevice!.disconnect();
      BattlePass.battlepassDevice = null;
      BattlePass.readCharacteristic = null;
      BattlePass.writeCharacteristic = null;
    }
  }

  @override
  Future<BattlePassHeader?> getHeaderFromBattlePass() async {
    if (BattlePass.battlepassDevice == null) {
      return null;
    }

    if (BattlePass.readCharacteristic == null) {
      return null;
    }

    if (BattlePass.writeCharacteristic == null) {
      return null;
    }

    await BattlePass.writeCharacteristic!
        .write([headerByte], withoutResponse: true);
    await waitWhile(() => readBuffer.length != 1)
        .timeout(const Duration(seconds: 10), onTimeout: () {
      readBuffer.clear();
      throw Exception("Lost connection to Battlepass");
    });

    var header = readBuffer[0];
    readBuffer.clear();

    var maxLaunchSpeed = int.parse(getBytes(header, 14, 2), radix: 16);
    var launchCount = int.parse(getBytes(header, 18, 2), radix: 16);
    var pageCount = getBytes(header, 22, 1);

    return BattlePassHeader(maxLaunchSpeed, launchCount, pageCount);
  }

  @override
  Future<BattlePassLaunchData?> getLaunchDataFromBattlePass() async {
    var header = await getHeaderFromBattlePass();
    if (header == null) {
      return null;
    }

    await BattlePass.writeCharacteristic!
        .write([getDataByte], withoutResponse: true);

    await waitWhile(() => readBuffer.isEmpty)
        .timeout(const Duration(seconds: 10), onTimeout: () {
      readBuffer.clear();
      throw Exception("Lost connection to Battlepass");
    });
    await waitWhile(() => !readBuffer.last.startsWith(header.pageCount))
        .timeout(const Duration(seconds: 10), onTimeout: () {
      readBuffer.clear();
      throw Exception("Lost connection to Battlepass");
    });

    var launches = readBuffer.map((str) => str.substring(2)).join();
    readBuffer.clear();

    var launchArray = splitIntoChunksUntilZeros(launches);
    var launchPoints = launchArray
        .map((str) => int.parse(getBytes(str, 0, 2), radix: 16))
        .toList();

    return BattlePassLaunchData(header, launchPoints);
  }

  @override
  Future<void> clearBattlePassData() async {
    await BattlePass.writeCharacteristic!
        .write([clearDataByte], withoutResponse: true);

    await waitWhile(() => readBuffer.length < 2)
        .timeout(const Duration(seconds: 10), onTimeout: () {
      readBuffer.clear();
      throw Exception("Lost connection to Battlepass");
    });
    //print(readBuffer[1]);
    var pageCount = getBytes(readBuffer[1], 22, 1);
    await waitWhile(() => !readBuffer.last.startsWith(pageCount))
        .timeout(const Duration(seconds: 10), onTimeout: () {
      readBuffer.clear();
      throw Exception("Lost connection to Battlepass");
    });

    readBuffer.clear();
  }
}
