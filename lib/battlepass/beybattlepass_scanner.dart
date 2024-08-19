import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:logger/logger.dart';
import 'battlepass_models.dart';
import 'battlepass_utils.dart';

class BeyBattlePassScanner extends GetxController {
  static const headerByte = 0x51;
  static const getDataByte = 0x74;
  static const clearDataByte = 0x75;

  static BluetoothDevice? battlepass;
  static BluetoothCharacteristic? readCharacteristic;
  static BluetoothCharacteristic? writeCharacteristic;

  static List<String> readBuffer = [];
  static Completer<void> readLock = Completer<void>();

  static Future<void> scanForBattlePass() async {
    var logger = Logger();
    try {
      logger.i("Scanning");

      FlutterBluePlus.onScanResults.listen(
        (results) {
          if (results.isNotEmpty) {
            ScanResult r = results.last;
            logger.i('${r.device.remoteId}: "${r.advertisementData.advName}" found!');
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

  static Future<void> endScanForBattlePass() async {
    await FlutterBluePlus.stopScan();
  }

  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  static Future<void> connectToBattlePass(BluetoothDevice battlepass) async {
    BeyBattlePassScanner.battlepass = battlepass;
    if (BeyBattlePassScanner.battlepass != null) {
      await BeyBattlePassScanner.battlepass!.connect();

      List<BluetoothService> services =
          await BeyBattlePassScanner.battlepass!.discoverServices();

      var mainService = services[0];
      if (services[0].uuid.str.startsWith("00001")) {
        mainService = services[1];
      }

      BeyBattlePassScanner.readCharacteristic = mainService.characteristics[1];
      BeyBattlePassScanner.writeCharacteristic = mainService.characteristics[0];

      final subscription = BeyBattlePassScanner
          .readCharacteristic!.onValueReceived
          .listen((value) {
        //print(convertIntListToHexString(value));
        readBuffer.add(convertIntListToHexString(value));
      });

      await BeyBattlePassScanner.readCharacteristic!.setNotifyValue(true);
      BeyBattlePassScanner.battlepass!.cancelWhenDisconnected(subscription);
    }
  }

  static Future<void> disconnectFromBattlePass() async {
    if (BeyBattlePassScanner.battlepass != null) {
      await BeyBattlePassScanner.readCharacteristic!.setNotifyValue(false);
      await BeyBattlePassScanner.battlepass!.disconnect();
      BeyBattlePassScanner.battlepass = null;
      BeyBattlePassScanner.readCharacteristic = null;
      BeyBattlePassScanner.writeCharacteristic = null;
    }
  }

  static Future<BattlePassHeader?> getHeaderFromBattlePass() async {
    if (BeyBattlePassScanner.battlepass == null) {
      return null;
    }

    if (BeyBattlePassScanner.readCharacteristic == null) {
      return null;
    }

    if (BeyBattlePassScanner.writeCharacteristic == null) {
      return null;
    }

    await BeyBattlePassScanner.writeCharacteristic!
        .write([headerByte], withoutResponse: true);
    await waitWhile(() => readBuffer.length != 1);

    var header = readBuffer[0];
    readBuffer.clear();

    var maxLaunchSpeed = int.parse(getBytes(header, 14, 2), radix: 16);
    var launchCount = int.parse(getBytes(header, 18, 2), radix: 16);
    var pageCount = getBytes(header, 22, 1);

    //print(pageCount);

    return BattlePassHeader(maxLaunchSpeed, launchCount, pageCount);
  }

  static Future<BattlePassLaunchData?> getLaunchDataFromBattlePass() async {
    var header = await getHeaderFromBattlePass();
    if (header == null) {
      return null;
    }

    await BeyBattlePassScanner.writeCharacteristic!
        .write([getDataByte], withoutResponse: true);

    await waitWhile(() => readBuffer.isEmpty);
    await waitWhile(() => !readBuffer.last.startsWith(header.pageCount));

    var launches = readBuffer.map((str) => str.substring(2)).join();
    readBuffer.clear();

    var launchArray = splitIntoChunksUntilZeros(launches);
    var launchPoints = launchArray
        .map((str) => int.parse(getBytes(str, 0, 2), radix: 16))
        .toList();

    return BattlePassLaunchData(header, launchPoints);
  }

  static Future<void> clearBattlePassData() async {
    await BeyBattlePassScanner.writeCharacteristic!
        .write([clearDataByte], withoutResponse: true);

    await waitWhile(() => readBuffer.length < 2);
    //print(readBuffer[1]);
    var pageCount = getBytes(readBuffer[1], 22, 1);
    await waitWhile(() => !readBuffer.last.startsWith(pageCount));

    readBuffer.clear();
  }

  Stream<List<ScanResult>> get scanResult => FlutterBluePlus.scanResults;
}
