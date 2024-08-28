import 'package:bey_stats/services/battle_pass_factory.dart';
import 'package:bey_stats/structs/battlepass_ble_device.dart';
import 'package:bey_stats/widgets/scan_result_card.dart';
import 'package:flutter/material.dart';

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
    return ListView.builder(
      shrinkWrap: true,
      itemCount: battlepassItems.length,
      itemBuilder: (context, index) {
        final btlpass = battlepassItems[index];
        return ScanResultCard(
            battlepass: btlpass, factory: factory, onPair: onPair);
      },
    );
  }
}
