import 'package:bey_stats/widgets/battlepassWidgets/launch_data_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class StatsOnboarding extends StatelessWidget {
  final VoidCallback goNext;
  final VoidCallback cancel;

  const StatsOnboarding(this.goNext, this.cancel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppLocalizations.of(context)!.resultsTitle,
            style: const TextStyle(fontSize: 20.0)),
        Expanded(
          child: LaunchDataLoader(cancel: cancel),
        ),
      ],
    );
  }
}