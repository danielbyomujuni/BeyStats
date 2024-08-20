import 'package:bey_stats/structs/launch_data.dart';
import 'package:bey_stats/widgets/format_date_time.dart';
import 'package:bey_stats/widgets/number_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';

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
          "Session ${launch.sessionNumber}: ${launch.id}",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onTertiary,
          ),
        ),
        trailing: FormatDateTime(launchDate: launch.launchDate),
      ),
    );

    if (dismissible) {
      return SwipeActionCell(
          key: ValueKey(launch.sessionNumber),

          /// this key is necessary
          trailingActions: <SwipeAction>[
            SwipeAction(
                title: "Delete",
                widthSpace: 120,
                onTap: (CompletionHandler handler) async {
                  if (onDismissed != null) {
                    await onDismissed!();
                  }
                },
                color: Colors.red),
          ],
          child: card);
    } else {
      return card;
    }
  }
}
