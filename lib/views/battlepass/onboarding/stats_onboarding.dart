import 'dart:math';

import 'package:bey_stats/battlepass/battlepass_models.dart';
import 'package:bey_stats/services/battle_pass.dart';
import 'package:bey_stats/widgets/database_instance.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
    var logger = Logger();

    return Column(
      children: [
        const Text("Results", style: TextStyle(fontSize: 20.0)),
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
                  
                  logger.e(snapshot.error);
                  logger.e(scoreSnapshot.error);
                  return const Text("Unable to get Data from Battlepass");
                }

                var speedPercentage = snapshot.data!.header.maxLaunchSpeed /
                    (scoreSnapshot.data! + 1);

                logger.d(min(1.0, speedPercentage));
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
                            const GaugeAnnotation(
                                angle: 270,
                                positionFactor: 0.18,
                                verticalAlignment: GaugeAlignment.far,
                                widget: Text('Max Launch Power:',
                                    style: TextStyle(fontSize: 19))),
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
                                    'Launch Count: ${snapshot.data!.header.launchCount}',
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
                          logger.d(await db.getLaunches());
                          logger.d(await db.getSessionTimeMax());
                          logger.d(await db.getAllTimeMax());

                          await BattlePass().clearBattlePassData();
                          // clear
                          widget.cancel();
                        },
                        child: const Text('SAVE'),
                      )),
                      const SizedBox(width: 15.0),
                      Expanded(
                          child: OutlinedButton(
                        onPressed: () {
                          widget.cancel();
                        },
                        child: const Text('Cancel'),
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
