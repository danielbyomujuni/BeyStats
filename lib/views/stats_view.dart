import 'package:bey_stats/battlepass/database_observer.dart';
import 'package:bey_stats/widgets/launch_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatsView extends StatelessWidget {
  const StatsView({super.key});

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
                dismissible: true,
                launches: () => notifier.launchData,
              ))
            ],
          );
        },
      ),
    );
  }
}
