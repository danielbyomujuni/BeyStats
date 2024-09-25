import 'package:bey_stats/services/battle_pass_factory.dart';
import 'package:bey_stats/services/logger.dart';
import 'package:bey_stats/structs/battlepass_ble_device.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
class ScanResultCard extends StatefulWidget {
  final VoidCallback onPair;
  final BattlepassBleDevice battlepass;
  final AbstractBattlePassFactory factory;

  const ScanResultCard(
      {super.key,
      required this.battlepass,
      required this.factory,
      required this.onPair});

  @override
  State<ScanResultCard> createState() => _ScanResultCardState();
}

class _ScanResultCardState extends State<ScanResultCard> {
  bool _selected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      elevation: 2,
      child: ListTile(
        title: Text("Battlepass (${widget.battlepass.battlepassID})"),
        trailing: !_selected
            ? Text(widget.battlepass.rssi.toString())
            : LoadingAnimationWidget.threeArchedCircle(
                color: Theme.of(context).indicatorColor, size: 20.0),
        onTap: () async {
          setState(() {
            _selected = true;
          });
          Logger.info("Connecting to Battle Pass");
          await widget.factory.connectToBattlePass(widget.battlepass);
          widget.onPair();
        },
      ),
    );
  }
}
