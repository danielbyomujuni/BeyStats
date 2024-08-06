import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class BeyBattlePassScanner extends GetxController {
  static const HEADER_BYTE = 0x51;
  static const GET_DATA_BYTE = 0x74;
  static const CLEAR_DATA_BYTE = 0x75;

  static BluetoothDevice? battlepass;
  static BluetoothCharacteristic? read_charactistic;
  static BluetoothCharacteristic? write_charactistic;

  static List<String> readBuffer = [];

  static Completer<void> read_lock = Completer();

  Future scanForBattlePass() async {
    try {
      print("scanning");

      FlutterBluePlus.onScanResults.listen(
        (results) {
          if (results.isNotEmpty) {
            ScanResult r = results.last; // the most recently found device
            print(
                '${r.device.remoteId}: "${r.advertisementData.advName}" found!');
          }
        },
        onError: (e) => print(e),
      );

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

  static Future<void> connectToBattlePass(BluetoothDevice battlepass) async {
    BeyBattlePassScanner.battlepass = battlepass;
    if (BeyBattlePassScanner.battlepass != null) {
      await BeyBattlePassScanner.battlepass!.connect();

      List<BluetoothService> services =
          await BeyBattlePassScanner.battlepass!.discoverServices();

      var main_service = services[0];
      if (services[0].uuid.str.startsWith("00001")) {
        main_service = services[1];
      }

      //print(services.length);

      //for (var c in main_service.characteristics) {
      //  print(c.characteristicUuid);
      //}

      //print(main_service.characteristics.length);

      // 0 read
      BeyBattlePassScanner.read_charactistic = main_service.characteristics[1];
      // 1 write
      BeyBattlePassScanner.write_charactistic = main_service.characteristics[0];

      final subscription = BeyBattlePassScanner
          .read_charactistic!.onValueReceived
          .listen((value) {
        readBuffer.add(convertIntListToHexString(value));
        //print("added to buffer");
      });
      await BeyBattlePassScanner.read_charactistic!.setNotifyValue(true);

      BeyBattlePassScanner.battlepass!.cancelWhenDisconnected(subscription);
    }
  }

  static Future<void> disconnectFromBattlePass() async {
    if (BeyBattlePassScanner.battlepass != null) {
      await BeyBattlePassScanner.read_charactistic!.setNotifyValue(false);
      await BeyBattlePassScanner.battlepass!.disconnect();
      BeyBattlePassScanner.battlepass = null;
      BeyBattlePassScanner.read_charactistic = null;
      BeyBattlePassScanner.write_charactistic = null;
    }
  }

  static Future<BattlePassHeader?> getHeaderFromBattlePass() async {
    if (BeyBattlePassScanner.battlepass == null) {
      return null;
    }

    if (BeyBattlePassScanner.read_charactistic == null) {
      return null;
    }
    if (BeyBattlePassScanner.write_charactistic == null) {
      return null;
    }

    // Writes to a characteristic
    await BeyBattlePassScanner.write_charactistic!
        .write([HEADER_BYTE], withoutResponse: true);

    await waitWhile(() => readBuffer.length != 1);

    var header = readBuffer[0]; //get buffer
    readBuffer.clear(); //empty buffer

    //parse buffer

    var maxLaunchSpeed = int.parse(get_bytes(header, 14, 2), radix: 16);
    var launch_count = int.parse(get_bytes(header, 18, 2), radix: 16);
    var page_count = get_bytes(header, 22, 1);

    var header_struct =
        BattlePassHeader(maxLaunchSpeed, launch_count, page_count);

    return header_struct;
  }

  static Future<BattlePassLaunchData?> getLaunchDataFromBattlePass() async {
    var header = await getHeaderFromBattlePass();
    if (header == null) {
      return null;
    }

    await BeyBattlePassScanner.write_charactistic!
        .write([GET_DATA_BYTE], withoutResponse: true);

    await waitWhile(() => readBuffer.isEmpty);
    await waitWhile(() => !readBuffer.last.startsWith(header.page_count));

    var launches = readBuffer.map((str) => str.substring(2)).join();
    readBuffer.clear();
    var launchArray = splitIntoChunksUntilZeros(launches);
    var launchPoints = launchArray
        .map((str) => int.parse(get_bytes(str, 0, 2), radix: 16))
        .toList();

    return BattlePassLaunchData(header, launchPoints);
  }
}

String convertIntListToHexString(List<int> intList) {
  return intList
      .map((int value) => value.toRadixString(16).padLeft(2, '0'))
      .join();
}

Future waitWhile(bool test(), [Duration pollInterval = Duration.zero]) {
  var completer = new Completer();
  check() {
    if (!test()) {
      completer.complete();
    } else {
      new Timer(pollInterval, check);
    }
  }

  check();
  return completer.future;
}

String get_bytes(String hex_string, int pos, int words) {
  var byte_segment = hex_string.substring(pos, pos + (words * 2));

  int n = byte_segment.length;
  List<String> flipped = List<String>.filled(n, '');

  for (int i = 0; i < n; i += 2) {
    flipped[i] = byte_segment[n - i - 2];
    flipped[i + 1] = byte_segment[n - i - 1];
  }

  return flipped.join();
}

List<String> splitIntoChunksUntilZeros(String input) {
  List<String> chunks = [];
  int length = input.length;

  for (int i = 0; i < length; i += 4) {
    String chunk = input.substring(i, i + 4);
    if (chunk == "0000") {
      break;
    }
    chunks.add(chunk);
  }

  return chunks;
}

class BattlePassHeader {
  int maxLaunchSpeed;
  int launch_count;
  String page_count;
  BattlePassHeader(this.maxLaunchSpeed, this.launch_count, this.page_count);
}

class BattlePassLaunchData {
  BattlePassHeader header;
  List<int> launches;
  BattlePassLaunchData(this.header, this.launches);
}
