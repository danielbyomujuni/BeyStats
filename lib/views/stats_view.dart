import 'package:bey_stats/battlepass/database_observer.dart';
import 'package:bey_stats/widgets/format_date_time.dart';
import 'package:bey_stats/widgets/launch_list.dart';
import 'package:bey_stats/widgets/number_display.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StatsView extends StatelessWidget {
  const StatsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseObserver().updateMaxValues();

    return ChangeNotifierProvider(
      create: (context) => DatabaseObserver(),
      child: Consumer<DatabaseObserver>(
        builder: (context, notifier, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                      style: const TextStyle(fontSize: 12.2),
                      "Launches (${notifier.launchCount})")),
              Expanded(
                  child: LaunchList(
                      launches: notifier.launchData.reversed.toList()))
            ],
          );
        },
      ),
    );
  }
}
