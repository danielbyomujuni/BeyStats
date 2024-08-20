import 'package:bey_stats/services/battle_pass_factory.dart';
import 'package:bey_stats/structs/battlepass_ble_device.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ScanResultList extends StatelessWidget {
  final VoidCallback onPair;
  final List<BattlepassBleDevice> battlepassItems;
  final AbstractBattlePassFactory factory;

  const ScanResultList(
      {super.key,
      required this.battlepassItems,
      required this.onPair,
      required this.factory});

  @override
  Widget build(BuildContext context) {
    var logger = Logger();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: battlepassItems.length,
      itemBuilder: (context, index) {
        final btlpass = battlepassItems[index];
        return Card(
          elevation: 2,
          child: ListTile(
            title: Text(btlpass.name),
            subtitle: Text(btlpass.address),
            trailing: Text(btlpass.rssi.toString()),
            onTap: () async {
              logger.i("Connect");
              await factory.connectToBattlePass(btlpass);
              onPair();
            },
          ),
        );
      },
    );
  }
}
