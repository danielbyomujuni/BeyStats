import 'package:bey_stats/battlepass/database_observer.dart';
import 'package:bey_stats/structs/launch_data.dart';
import 'package:bey_stats/widgets/database_instance.dart';
import 'package:bey_stats/widgets/launch_power_card.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';

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
      final newLaunches = await widget.launches();
      if (newLaunches.length >= _launches.length - deleted ||
          !widget.dismissible) {
        _launches = await widget.launches();
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

    Logger().d("delete launch");
    var db = await DatabaseInstance.getInstance();
    await db.deleteLaunchData(launch);
  }

  @override
  Widget build(BuildContext context) {
    if (_launches.isEmpty) {
      return Center(
        child: Text(
          'No Launches',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 18,
          ),
        ),
      );
    }
    print(_launches.map((e) => "${e.id}:${e.launchPower}").toList());
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
