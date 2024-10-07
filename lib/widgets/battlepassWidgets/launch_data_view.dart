import 'package:bey_stats/battlepass/battlepass_models.dart';
import 'package:bey_stats/widgets/battlepassWidgets/actions_button.dart';
import 'package:bey_stats/widgets/battlepassWidgets/launch_speed_gauge.dart';
import 'package:flutter/material.dart';

class LaunchDataView extends StatelessWidget {
  final BattlePassLaunchData launchData;
  final double speedPercentage;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const LaunchDataView({
    required this.launchData,
    required this.speedPercentage,
    required this.onSave,
    required this.onCancel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  LayoutBuilder(
  builder: (context, constraints) => Container(
      padding: const EdgeInsets.all(0),
      height: constraints.maxWidth / 1.5,  // WORKAROUND
      child: Column(
      children: [
         Flexible(
            child: LaunchSpeedGauge(
                launchData: launchData, speedPercentage: speedPercentage)),
        ActionButtons(
          onSave: onSave,
          onCancel: onCancel,
        ),
      ],
    )));
  }
}
