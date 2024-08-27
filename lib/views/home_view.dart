import 'package:bey_stats/battlepass/database_observer.dart';
import 'package:bey_stats/widgets/info_card.dart';
import 'package:bey_stats/widgets/launch_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                    title: AppLocalizations.of(context)!.allTimeInfo,
                    subtitle: AppLocalizations.of(context)!.launchPowerLabel,
                    unit: ' LP',
                    value: notifier.allTimeMax,
                  ),
                  InfoCard(
                    title: AppLocalizations.of(context)!.lastSessionInfo,
                    subtitle: AppLocalizations.of(context)!.launchPowerLabel,
                    unit: ' LP',
                    value: notifier.sessionMax,
                  ),
                  InfoCard(
                    title: AppLocalizations.of(context)!.launchCountLabel,
                    subtitle: AppLocalizations.of(context)!.totalLaunchesLabel,
                    unit: ' ${AppLocalizations.of(context)!.launchesLabel}',
                    value: notifier.launchCount,
                  ),
                  InfoCard(
                    title: AppLocalizations.of(context)!.sessionCountInfo,
                    subtitle: AppLocalizations.of(context)!.totalSessionsLabel,
                    unit: ' ${AppLocalizations.of(context)!.sessionsLabel}',
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
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            AppLocalizations.of(context)!.topFiveLaunchesInfo,
                            style: const TextStyle(fontSize: 20),
                          )),
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
