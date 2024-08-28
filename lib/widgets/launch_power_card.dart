import 'package:bey_stats/structs/launch_data.dart';
import 'package:bey_stats/widgets/format_date_time.dart';
import 'package:bey_stats/widgets/number_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LaunchPowerCard extends StatelessWidget {
  final LaunchData launch;
  final bool dismissible;
  final Future<void> Function()? onDismissed;

  const LaunchPowerCard({
    super.key,
    required this.launch,
    this.dismissible = false,
    this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Card(
      color: Theme.of(context).colorScheme.secondary,
      child: ListTile(
        title: NumberDisplay(
          style: TextStyle(
            fontFamily: "monospace",
            color: Theme.of(context).colorScheme.primary,
          ),
          number: launch.launchPower,
        ),
        subtitle: Text(
          "${AppLocalizations.of(context)!.sessionLabel}: ${launch.sessionNumber}",
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        trailing: FormatDateTime(launchDate: launch.launchDate),
      ),
    );

    if (dismissible) {
      return Dismissible(
        key: ValueKey(launch.id),
        onDismissed: (d) async {
          if (onDismissed != null) {
            await onDismissed!();
          }
        },
        direction: DismissDirection.endToStart,
        background: Padding(
            padding: const EdgeInsets.fromLTRB(
              0,
              5.0,
              5.0,
              5.0,
            ),
            child: Container(
              clipBehavior: Clip.hardEdge,
              color: Theme.of(context).colorScheme.error,
              alignment: Alignment.centerRight,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              )),
              padding: const EdgeInsets.all(10.0),
              child: const Icon(Icons.delete, color: Colors.white),
            )),
        child: card,
      );
    } else {
      return card;
    }
  }
}
