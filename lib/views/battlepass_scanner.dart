import 'package:bey_combat_logger/battlepass/beybattlepass_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BattlepassScanner extends StatefulWidget {
  const BattlepassScanner({super.key});
  @override
  State<BattlepassScanner> createState() => _BattlepassScannerState();
}

class _BattlepassScannerState extends State<BattlepassScanner> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BeyBattlePassScanner>(
      init: BeyBattlePassScanner(),
      builder: (BeyBattlePassScanner controller) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<List<ScanResult>>(
                  stream: controller.scanResult,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                          child: Scrollbar(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final data = snapshot.data![index];
                              return Card(
                                elevation: 2,
                                child: ListTile(
                                  title: Text(data.device.platformName),
                                  subtitle: Text(data.device.remoteId.str),
                                  trailing: Text(data.rssi.toString()),
                                  onTap: () async {
                                    print("connect");
                                    await BeyBattlePassScanner
                                        .connectToBattlePass(data.device);

                                    var results = await BeyBattlePassScanner
                                        .getLaunchDataFromBattlePass();

                                    print(
                                        "Launch Scores: ${results!.launches}");
                                    print(
                                        "Launches: ${results.header.launch_count}");
                                    print(
                                        "Highscore: ${results.header.maxLaunchSpeed}");

                                    print("navigate to page");
                                    await BeyBattlePassScanner
                                        .disconnectFromBattlePass();
                                  },
                                ),
                              );
                            }),
                      ));
                    } else {
                      return const Center(
                        child: Text("No Device Found"),
                      );
                    }
                  }),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await controller.scanForBattlePass();
                    // await controller.disconnectDevice();
                  },
                  child: Text("SCAN")),
            ],
          ),
        );
      },
    );
  }
}
