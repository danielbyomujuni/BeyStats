import 'package:bey_stats/structs/launch_data.dart';
import 'package:bey_stats/widgets/format_date_time.dart';
import 'package:bey_stats/widgets/number_display.dart';
import 'package:flutter/material.dart';

class LaunchList extends StatelessWidget {
  final List<LaunchData> launches;

  const LaunchList({super.key, required this.launches});

  @override
  Widget build(BuildContext context) {
    if (launches.isEmpty) {
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

    return ListView(
      primary: false,
      shrinkWrap: true,
      children: launches.map((launch) {
        return Card(
          child: ListTile(
            title: NumberDisplay(
              style: TextStyle(
                fontFamily: "monospace",
                color: Theme.of(context).colorScheme.primary,
              ),
              number: launch.launchPower,
            ),
            subtitle: Text(
              "Session ${launch.sessionNumber}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            trailing: FormatDateTime(launchDate: launch.launchDate),
          ),
        );
      }).toList(),
    );
  }
}
