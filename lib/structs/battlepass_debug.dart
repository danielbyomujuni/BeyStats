import 'package:bey_stats/battlepass/battlepass_models.dart';

class BattlepassDebug {
  List<ServiceDebug> services = [];
  String? mainService;
  String? readCharacteristic;
  String? writeCharacteristic;
  BattlePassLaunchData? debugLaunchData;
  BattlePassHeader? debugHeaderData;

  void addService(ServiceDebug service) {
    services.add(service);
  }

  void setMainService(String service) {
    mainService = service;
  }

  void setReadCharacteristic(String characteristic) {
    readCharacteristic = characteristic;
  }

  void setWriteCharacteristic(String characteristic) {
    writeCharacteristic = characteristic;
  }

  void setLaunchData(BattlePassLaunchData launchdata) {
    debugLaunchData = launchdata;
  }

  void setHeaderData(BattlePassHeader headerdata) {
    debugHeaderData = headerdata;
  }

  Map<String, dynamic> toJson() => {
        'services': services.map((e) => e.toJson()).toList(),
        'mainService': mainService,
        'readCharacteristic': readCharacteristic,
        'writeCharacteristic': writeCharacteristic,
        'debugHeaderData': debugHeaderData?.toJson() ?? "NULL",
        'debugLaunchData': debugLaunchData?.toJson() ?? "NULL"
      };
}

class ServiceDebug {
  late String uuid;
  List<CharacteristicDebug> characteristics = [];

  ServiceDebug(this.uuid);

  void addCharacteristic(CharacteristicDebug characteristic) {
    characteristics.add(characteristic);
  }

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'characteristics': characteristics.map((e) => e.toJson()).toList(),
      };
}

class CharacteristicDebug {
  late String uuid;

  CharacteristicDebug(this.uuid);

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
      };
}
