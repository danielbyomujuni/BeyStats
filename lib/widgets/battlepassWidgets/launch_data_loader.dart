import 'dart:math';

import 'package:bey_stats/battlepass/battlepass_models.dart';
import 'package:bey_stats/services/battle_pass.dart';
import 'package:bey_stats/services/database/launches_database.dart';
import 'package:bey_stats/widgets/battlepassWidgets/launch_data_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../services/logger.dart';

class LaunchDataLoader extends StatefulWidget {
  final VoidCallback cancel;

  const LaunchDataLoader({required this.cancel, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LaunchDataLoaderState createState() => _LaunchDataLoaderState();
}

class _LaunchDataLoaderState extends State<LaunchDataLoader> {
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
    return FutureBuilder<int>(
      future: LaunchesDatabase.getInstance().then((db) => db.getAllTimeMax()),
      builder: (context, scoreSnapshot) {
        return FutureBuilder<BattlePassLaunchData?>(
          future: _launchDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingAnimationWidget.threeArchedCircle(
                color: Theme.of(context).indicatorColor,
                size: 200,
              );
            } else if (snapshot.hasError ||
                !snapshot.hasData ||
                scoreSnapshot.hasError ||
                !scoreSnapshot.hasData) {
              return _buildError(context, snapshot, scoreSnapshot);
            }

            var launchData = snapshot.data!;
            var speedPercentage = launchData.header.maxLaunchSpeed /
                (scoreSnapshot.data! + 1);

            Logger.debug("Launch Percentage: ${min(1.0, speedPercentage)}");
            return LaunchDataView(
              launchData: launchData,
              speedPercentage: speedPercentage,
              onSave: () async {
                var db = await LaunchesDatabase.getInstance();
                await db.saveLaunches(launchData.launches);
                Logger.debug("Launches: ${await db.getLaunches()}");
                Logger.debug("Session Max: ${await db.getSessionTimeMax()}");
                Logger.debug("All time Max: ${await db.getAllTimeMax()}");
                await BattlePass().clearBattlePassData();
                widget.cancel();
              },
              onCancel: widget.cancel,
            );
          },
        );
      },
    );
  }

  Widget _buildError(BuildContext context, AsyncSnapshot<BattlePassLaunchData?> snapshot, AsyncSnapshot<int> scoreSnapshot) {
    Logger.error(snapshot.error.toString());
    Logger.error(scoreSnapshot.error.toString());
    return Column(children: [
      Expanded(
        child: FittedBox(
          fit: BoxFit.fill,
          child: Icon(
            Icons.error,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
      Text(AppLocalizations.of(context)!.battlepassError1),
      Text(AppLocalizations.of(context)!.battlepassError2),
    ]);
  }
}

