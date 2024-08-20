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
  late List<LaunchData> _launches;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    DatabaseObserver().addListener(() async {
      setState(() {
        loading = true;
      });
      _launches = await widget.launches();
      Future.delayed(
          const Duration(seconds: 1),
          () => {
                setState(() {
                  loading = false;
                })
              });
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
    if (loading) {
      return Expanded(
        child: LoadingAnimationWidget.twistingDots(
          leftDotColor: const Color(0xFF1A1A3F),
          rightDotColor: const Color(0xFFEA3799),
          size: 200,
        ),
      );
    }

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
            setState(() {
              loading = true;
            });
            await _removeLaunch(launch);
          },
        );
      }).toList(),
    );
  }
}
