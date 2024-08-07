import 'package:bey_combat_logger/battlepass/battlepass_models.dart';
import 'package:bey_combat_logger/battlepass/beybattlepass_scanner.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
          child: FutureBuilder<BattlePassLaunchData?>(
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
                  snapshot.data == null) {
                return const Text("Unable to get Data from Battlepass");
              }
              print(snapshot.data!.header.maxLaunchSpeed);
              print(snapshot.data!.header.launchCount);

              return Column(
                children: [
                  SfRadialGauge(
                    enableLoadingAnimation: true,
                    animationDuration: 4500,
                    axes: <RadialAxis>[
                      RadialAxis(
                        showTicks: false,
                        showLabels: false,
                        startAngle: 180,
                        endAngle: 180,
                        radiusFactor: 0.9,
                        axisLineStyle: const AxisLineStyle(
                            // Dash array not supported in web
                            thickness: 30,
                            dashArray: <double>[8, 10]),
                      ),
                      RadialAxis(
                          showTicks: false,
                          showLabels: false,
                          startAngle: 180,
                          radiusFactor: 0.9,
                          annotations: const <GaugeAnnotation>[
                            GaugeAnnotation(
                                angle: 270,
                                verticalAlignment: GaugeAlignment.far,
                                widget: Text(' 63%',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Times',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25)))
                          ],
                          axisLineStyle: const AxisLineStyle(
                              color: Color(0xFF00A8B5),
                              gradient: SweepGradient(colors: <Color>[
                                Color(0xFF06974A),
                                Color(0xFFF2E41F)
                              ], stops: <double>[
                                0.25,
                                0.75
                              ]),
                              thickness: 30,
                              dashArray: <double>[8, 10]))
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
