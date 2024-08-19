import 'package:bey_stats/services/battle_pass_factory.dart';
import 'package:bey_stats/structs/battlepass_ble_device.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bey_stats/widgets/scan_result_list.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BattlepassScanner extends StatefulWidget {
  final VoidCallback _onPair;

  const BattlepassScanner(this._onPair, {super.key});

  @override
  State<BattlepassScanner> createState() => _BattlepassScannerState();
}

class _BattlepassScannerState extends State<BattlepassScanner> {
  @override
  void initState() {
    BattlePassFactory().scanForBattlePass();
    super.initState();
  }

  @override
  void dispose() {
    BattlePassFactory().endScanForBattlePass();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var factory = BattlePassFactory();


    return GetBuilder<AbstractBattlePassFactory>(
      init: factory,
      builder: (AbstractBattlePassFactory controller) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<List<BattlepassBleDevice>>(
                  stream: controller.getScanBattlePassResults(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return Expanded(
                        child: Scrollbar(
                          child: ScanResultList(
                              factory: factory,
                              battlepassItems: snapshot.data!,
                              onPair: widget._onPair),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
              Center(
                  child: LoadingAnimationWidget.threeArchedCircle(
                color: Theme.of(context).indicatorColor,
                size: 150,
              ))
            ],
          ),
        );
      },
    );
  }
}
