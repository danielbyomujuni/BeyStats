import 'package:bey_combat_logger/battlepass/beybattlepass_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:bey_combat_logger/widgets/scan_result_list.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BattlepassScanner extends StatefulWidget {
  VoidCallback _onPair;

  BattlepassScanner(this._onPair, {super.key});

  @override
  State<BattlepassScanner> createState() => _BattlepassScannerState();
}

class _BattlepassScannerState extends State<BattlepassScanner> {
  @override
  void initState() {
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
                        child: ScanResultList(
                            scanResults: snapshot.data!,
                            onPair: widget._onPair),
                      ),
                    );
                  } else {
                    return Center(
                      child: LoadingAnimationWidget.threeArchedCircle(
                        color: Theme.of(context).indicatorColor,
                        size: 200,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
