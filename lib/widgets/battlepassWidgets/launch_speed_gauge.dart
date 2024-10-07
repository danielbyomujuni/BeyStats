import 'dart:math';

import 'package:bey_stats/battlepass/battlepass_models.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LaunchSpeedGauge extends StatelessWidget {
  final BattlePassLaunchData launchData;
  final double speedPercentage;

  const LaunchSpeedGauge({
    required this.launchData,
    required this.speedPercentage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      animationDuration: 3000,
      axes: <RadialAxis>[
        RadialAxis(
          showTicks: false,
          showLabels: false,
          startAngle: 150,
          endAngle: 30,
          radiusFactor: 0.9,
          axisLineStyle: const AxisLineStyle(
            thickness: 30,
            dashArray: <double>[8, 10],
          ),
        ),
        RadialAxis(
          showTicks: false,
          showLabels: false,
          startAngle: 150,
          endAngle: 150 + (min(1.0, speedPercentage) + 0.01) * 240,
          radiusFactor: 0.9,
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              angle: 270,
              positionFactor: 0.18,
              verticalAlignment: GaugeAlignment.far,
              widget: Text(
                "${AppLocalizations.of(context)!.maxLaunchPowerLabel}:",
                style: const TextStyle(fontSize: 19),
              ),
            ),
            GaugeAnnotation(
              angle: 270,
              positionFactor: 0.1,
              verticalAlignment: GaugeAlignment.center,
              widget: Text(
                '${launchData.header.maxLaunchSpeed}',
                style: const TextStyle(fontSize: 19),
              ),
            ),
            GaugeAnnotation(
              angle: 270,
              positionFactor: 0,
              verticalAlignment: GaugeAlignment.near,
              widget: Text(
                '${AppLocalizations.of(context)!.launchCountLabel}: ${launchData.header.launchCount}',
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),
          ],
          axisLineStyle: AxisLineStyle(
            color: Theme.of(context).canvasColor,
            gradient: SweepGradient(
              colors: <Color>[
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.tertiary,
              ],
              stops: const <double>[
                0.25,
                0.75,
              ],
            ),
            thickness: 30,
            dashArray: const <double>[8, 10],
          ),
        ),
      ],
    );
  }
}
