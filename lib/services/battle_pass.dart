import 'dart:async';

import 'package:bey_stats/battlepass/battlepass_models.dart';
import 'package:bey_stats/battlepass/battlepass_utils.dart';
import 'package:bey_stats/structs/battlepass_ble_device.dart';
import 'package:bey_stats/structs/battlepass_debug.dart';
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

      BluetoothService? mainService;

      for (var service in services) {
        if (service.uuid.str.startsWith("00001") ||
            service.serviceUuid.str.startsWith("1800") ||
            service.serviceUuid.str.startsWith("1801") ||
            service.serviceUuid.str.startsWith("180a")) {
          continue;
        }
        mainService ??= service;
        break;
      }

      if (mainService == null) {
        throw Exception("Unable to get Bluetooth characteristics");
      }

      BattlePass.readCharacteristic = mainService.characteristics[1];
      BattlePass.writeCharacteristic = mainService.characteristics[0];

      //print(mainService.characteristics[1]);
      //print(mainService.characteristics[0]);

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
    await waitWhile(
            () => readBuffer.length != 1 || battlepassDevice!.isDisconnected)
        .timeout(const Duration(seconds: 60), onTimeout: () {
      readBuffer.clear();
      throw Exception("Lost connection to Battlepass");
    });

    if (battlepassDevice!.isDisconnected) {
      readBuffer.clear();
      throw Exception("Lost connection to Battlepass");
    }

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

    await waitWhile(
            () => readBuffer.isEmpty || battlepassDevice!.isDisconnected)
        .timeout(const Duration(seconds: 60), onTimeout: () {
      readBuffer.clear();
      throw Exception("Lost connection to Battlepass");
    });

    if (battlepassDevice!.isDisconnected) {
      readBuffer.clear();
      throw Exception("Lost connection to Battlepass");
    }

    await waitWhile(() =>
            !readBuffer.last.startsWith(header.pageCount) ||
            battlepassDevice!.isDisconnected)
        .timeout(const Duration(seconds: 60), onTimeout: () {
      readBuffer.clear();
      throw Exception("Lost connection to Battlepass");
    });

    if (battlepassDevice!.isDisconnected) {
      readBuffer.clear();
      throw Exception("Lost connection to Battlepass");
    }

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

    await waitWhile(
            () => readBuffer.length < 2 || battlepassDevice!.isDisconnected)
        .timeout(const Duration(seconds: 60), onTimeout: () {
      readBuffer.clear();
      throw Exception("Lost connection to Battlepass");
    });

    if (battlepassDevice!.isDisconnected) {
      readBuffer.clear();
      throw Exception("Lost connection to Battlepass");
    }

    //print(readBuffer[1]);
    var pageCount = getBytes(readBuffer[1], 22, 1);
    await waitWhile(() =>
            !readBuffer.last.startsWith(pageCount) ||
            battlepassDevice!.isDisconnected)
        .timeout(const Duration(seconds: 60), onTimeout: () {
      readBuffer.clear();
      throw Exception("Lost connection to Battlepass");
    });

    if (battlepassDevice!.isDisconnected) {
      readBuffer.clear();
      throw Exception("Lost connection to Battlepass");
    }

    readBuffer.clear();
  }

  Future<BattlepassDebug> getDebugInformation() async {
    if (battlepassDevice == null) {
      throw Exception("connection error");
    }

    BattlepassDebug data = BattlepassDebug();

    List<BluetoothService> services =
        await battlepassDevice!.discoverServices();

    for (var serve in services) {
      ServiceDebug service = ServiceDebug(serve.serviceUuid.str);
      for (var characteristics in serve.characteristics) {
        service.addCharacteristic(
            CharacteristicDebug(characteristics.characteristicUuid.str));
      }
      data.addService(service);
    }

    BluetoothService? mainService;
    for (var service in services) {
      if (service.uuid.str.startsWith("00001") ||
          service.serviceUuid.str.startsWith("1800") ||
          service.serviceUuid.str.startsWith("1801") ||
          service.serviceUuid.str.startsWith("180a")) {
        continue;
      }
      mainService ??= service;
      break;
    }

    if (mainService == null) {
      return data;
    }

    data.setMainService(mainService.uuid.str);
    data.setReadCharacteristic(
        mainService.characteristics[1].characteristicUuid.str);
    data.setWriteCharacteristic(
        mainService.characteristics[0].characteristicUuid.str);

    return data;
  }
}
