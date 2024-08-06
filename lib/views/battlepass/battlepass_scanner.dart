import 'package:bey_combat_logger/battlepass/beybattlepass_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BattlepassScanner extends StatefulWidget {
  const BattlepassScanner({super.key});
  @override
  State<BattlepassScanner> createState() => _BattlepassScannerState();
}

class _BattlepassScannerState extends State<BattlepassScanner> {
  @override
  void initState() {
    // TODO: implement initState
    BeyBattlePassScanner.scanForBattlePass();
    super.initState();
  }

  @override
  void dispose() {
    BeyBattlePassScanner.endScanForBattlePass();
    super.dispose();
  }

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
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
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
                                        "Launches: ${results.header.launchCount}");
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
                      return Center(
                        child: LoadingAnimationWidget.threeArchedCircle(
                          color: Theme.of(context).indicatorColor,
                          size: 200,
                        ),
                      );
                    }
                  })
            ],
          ),
        );
      },
    );
  }
}
