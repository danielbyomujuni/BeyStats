import 'dart:math';

import 'package:bey_stats/battlepass/battlepass_models.dart';
import 'package:bey_stats/services/battle_pass.dart';
import 'package:bey_stats/services/database_instance.dart';
import 'package:bey_stats/services/logger.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatsOnboarding extends StatefulWidget {
  final VoidCallback goNext;
  final VoidCallback cancel;

  const StatsOnboarding(this.goNext, this.cancel, {super.key});

  @override
  StatsOnboardingState createState() => StatsOnboardingState();
}

class StatsOnboardingState extends State<StatsOnboarding> {
  late Future<BattlePassLaunchData?> _launchDataFuture;

  @override
  void initState() {
    super.initState();
    _launchDataFuture = BattlePass().getLaunchDataFromBattlePass();
  }

  @override
  void dispose() {
    BattlePass().disconnectFromBattlePass();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppLocalizations.of(context)!.resultsTitle,
            style: const TextStyle(fontSize: 20.0)),
        Expanded(
          child: FutureBuilder<int>(future: () async {
            var data =
                await (await DatabaseInstance.getInstance()).getAllTimeMax();
            return data;
          }(), builder:
              (BuildContext context, AsyncSnapshot<int> scoreSnapshot) {
            return FutureBuilder<BattlePassLaunchData?>(
              future: _launchDataFuture,
              builder: (BuildContext context,
                  AsyncSnapshot<BattlePassLaunchData?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingAnimationWidget.threeArchedCircle(
                    color: Theme.of(context).indicatorColor,
                    size: 200,
                  );
                } else if (snapshot.hasError ||
                    !snapshot.hasData ||
                    scoreSnapshot.hasError ||
                    !scoreSnapshot.hasData ||
                    snapshot.data == null ||
                    scoreSnapshot.data == null) {
                  Logger.error(snapshot.error.toString());
                  Logger.error(scoreSnapshot.error.toString());
                  return Column(children: [
                    Expanded(
                        child: FittedBox(
                            fit: BoxFit.fill,
                            child: Icon(
                              Icons.error,
                              color: Theme.of(context).colorScheme.error,
                            ))),
                    Text(AppLocalizations.of(context)!.battlepassError1),
                    Text(AppLocalizations.of(context)!.battlepassError2)
                  ]);
                }

                var speedPercentage = snapshot.data!.header.maxLaunchSpeed /
                    (scoreSnapshot.data! + 1);

                Logger.debug("Launch Percentage: ${min(1.0, speedPercentage)}");
                return Column(
                  children: [
                    SfRadialGauge(
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
                              // Dash array not supported in web
                              thickness: 30,
                              dashArray: <double>[8, 10]),
                        ),
                        RadialAxis(
                          showTicks: false,
                          showLabels: false,
                          startAngle: 150,
                          endAngle:
                              150 + (min(1.0, speedPercentage) + 0.01) * 240,
                          radiusFactor: 0.9,
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                                angle: 270,
                                positionFactor: 0.18,
                                verticalAlignment: GaugeAlignment.far,
                                widget: Text(
                                    "${AppLocalizations.of(context)!.maxLaunchPowerLabel}:",
                                    style: const TextStyle(fontSize: 19))),
                            GaugeAnnotation(
                                angle: 270,
                                positionFactor: 0.1,
                                verticalAlignment: GaugeAlignment.center,
                                widget: Text(
                                    '${snapshot.data!.header.maxLaunchSpeed}',
                                    style: const TextStyle(fontSize: 19))),
                            GaugeAnnotation(
                                angle: 270,
                                positionFactor: 0,
                                verticalAlignment: GaugeAlignment.near,
                                widget: Text(
                                    '${AppLocalizations.of(context)!.launchCountLabel}: ${snapshot.data!.header.launchCount}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline))),
                          ],
                          axisLineStyle: AxisLineStyle(
                              color: Theme.of(context).canvasColor,
                              gradient: SweepGradient(colors: <Color>[
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.tertiary
                              ], stops: const <double>[
                                0.25,
                                0.75
                              ]),
                              thickness: 30,
                              dashArray: const <double>[8, 10]),
                        ),
                      ],
                    ),
                    Row(children: [
                      Expanded(
                          child: FilledButton(
                        onPressed: () async {
                          var db = await DatabaseInstance.getInstance();
                          await db.saveLaunches(snapshot.data!.launches);
                          Logger.debug("Launches: ${await db.getLaunches()}");
                          Logger.debug("Session Max: ${await db.getSessionTimeMax()}");
                          Logger.debug("All time Max: ${await db.getAllTimeMax()}");

                          await BattlePass().clearBattlePassData();
                          // clear
                          widget.cancel();
                        },
                        child: Text(AppLocalizations.of(context)!.saveLabel),
                      )),
                      const SizedBox(width: 15.0),
                      Expanded(
                          child: OutlinedButton(
                        onPressed: () {
                          widget.cancel();
                        },
                        child: Text(AppLocalizations.of(context)!.cancelLabel),
                      ))
                    ])
                  ],
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
