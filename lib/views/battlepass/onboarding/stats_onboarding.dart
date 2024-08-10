import 'dart:math';

import 'package:bey_combat_logger/battlepass/battlepass_models.dart';
import 'package:bey_combat_logger/battlepass/beybattlepass_scanner.dart';
import 'package:bey_combat_logger/battlepass/database_instance.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

const HIGH_SCORE = 10000;

class StatsOnboarding extends StatefulWidget {
  final VoidCallback goNext;
  final VoidCallback cancel;

  const StatsOnboarding(this.goNext, this.cancel, {super.key});

  @override
  _StatsOnboardingState createState() => _StatsOnboardingState();
}

class _StatsOnboardingState extends State<StatsOnboarding> {
  late Future<BattlePassLaunchData?> _launchDataFuture;

  @override
  void initState() {
    super.initState();
    _launchDataFuture = BeyBattlePassScanner.getLaunchDataFromBattlePass();
  }

  @override
  void dispose() {
    BeyBattlePassScanner.disconnectFromBattlePass();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  return const Text("Unable to get Data from Battlepass");
                }

                var speed_percentage = snapshot.data!.header.maxLaunchSpeed /
                    (scoreSnapshot.data! + 1);

                print(min(1.0, speed_percentage));
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
                              150 + (min(1.0, speed_percentage) + 0.01) * 240,
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
                          print(await db.getLaunches());
                          print(await db.getSessionTimeMax());
                          print(await db.getAllTimeMax());

                          await BeyBattlePassScanner.clearBattlePassData();
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
