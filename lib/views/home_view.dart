import 'package:bey_stats/battlepass/database_observer.dart';
import 'package:bey_stats/widgets/database_instance.dart';
import 'package:bey_stats/widgets/info_card.dart';
import 'package:bey_stats/widgets/launch_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseObserver().updateMaxValues();

    return ChangeNotifierProvider(
      create: (context) => DatabaseObserver(),
      child: Consumer<DatabaseObserver>(
        builder: (context, notifier, _) {
          return Scrollbar(
              child: SingleChildScrollView(
                  child: Column(children: [
            GridView.count(
                shrinkWrap: true,
                childAspectRatio: 1.5,
                crossAxisCount:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 2
                        : 4,
                primary: false,
                children: [
                  InfoCard(
                    title: 'All Time',
                    subtitle: 'Launch Power',
                    unit: ' LP',
                    value: notifier.allTimeMax,
                  ),
                  InfoCard(
                    title: 'Last Session',
                    subtitle: 'Launch Power',
                    unit: ' LP',
                    value: notifier.sessionMax,
                  ),
                  InfoCard(
                    title: 'Launch Count',
                    subtitle: 'Total Launches',
                    unit: ' Launches',
                    value: notifier.launchCount,
                  ),
                  InfoCard(
                    title: 'Session Count',
                    subtitle: 'Total Sessions',
                    unit: ' Sessions',
                    value: notifier.sessionCount,
                  ),
                ]),
            const SizedBox(
              height: 10,
            ),
            Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(25))),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 30.0),
                    child: Column(children: [
                      const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                              style: TextStyle(fontSize: 20),
                              "Top 5 Launches")),
                      LaunchList(
                        launches: () => notifier.topFive,
                      )
                    ])))
          ])));
        },
      ),
    );
  }
}
