import 'package:bey_stats/battlepass/beybattlepass_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScanResultList extends StatelessWidget {
  VoidCallback onPair = () {};
  final List<ScanResult> scanResults;

  ScanResultList({super.key, required this.scanResults, required this.onPair});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: scanResults.length,
      itemBuilder: (context, index) {
        final data = scanResults[index];
        return Card(
          elevation: 2,
          child: ListTile(
            title: Text(data.device.platformName),
            subtitle: Text(data.device.remoteId.str),
            trailing: Text(data.rssi.toString()),
            onTap: () async {
              print("Connect");
              await BeyBattlePassScanner.connectToBattlePass(data.device);

              //var results =
              //await BeyBattlePassScanner.getLaunchDataFromBattlePass();

              //print("Launch Scores: ${results!.launches}");
              //print("Launches: ${results.header.launchCount}");
              //print("Highscore: ${results.header.maxLaunchSpeed}");

              //print("Navigate to page");
              //await BeyBattlePassScanner.disconnectFromBattlePass();

              onPair();
            },
          ),
        );
      },
    );
  }
}
