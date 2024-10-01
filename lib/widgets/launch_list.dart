import 'package:bey_stats/battlepass/database_observer.dart';
import 'package:bey_stats/services/database/launches_database.dart';
import 'package:bey_stats/services/logger.dart';
import 'package:bey_stats/structs/launch_data.dart';
import 'package:bey_stats/widgets/launch_power_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LaunchList extends StatefulWidget {
  final List<LaunchData> Function() launches;
  final bool dismissible;

  const LaunchList({
    super.key,
    required this.launches,
    this.dismissible = false,
  });

  @override
  LaunchListState createState() => LaunchListState();
}

class LaunchListState extends State<LaunchList> {
  late List<LaunchData> _launches = [];
  int deleted = 0;

  @override
  void initState() {
    super.initState();
    DatabaseObserver().addListener(() async {
      final newLaunches = widget.launches();
      if (newLaunches.length >= _launches.length - deleted ||
          !widget.dismissible) {
        _launches = widget.launches();
        setState(() {
          deleted = 0;
        });
      }
    });
  }

  Future<void> _removeLaunch(LaunchData launch) async {
    setState(() {
      _launches.remove(launch);
    });

    Logger.debug("Deleting Launch");
    var db = await LaunchesDatabase.getInstance();
    await db.deleteLaunchData(launch);
  }

  @override
  Widget build(BuildContext context) {
    if (_launches.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noLaunchesLabel,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 18,
          ),
        ),
      );
    }
    //print(_launches.map((e) => "${e.id}:${e.launchPower}").toList());
    return ListView(
      primary: false,
      shrinkWrap: true,
      children: _launches.map((launch) {
        return LaunchPowerCard(
          launch: launch,
          dismissible: widget.dismissible,
          onDismissed: () async {
            await _removeLaunch(launch);
            setState(() {
              deleted += 1;
            });
          },
        );
      }).toList(),
    );
  }
}
