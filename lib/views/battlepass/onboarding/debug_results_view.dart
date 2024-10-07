import 'package:bey_stats/battlepass/battlepass_models.dart';
import 'package:bey_stats/widgets/battlepassWidgets/launch_data_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DebugResultsView extends StatelessWidget {
  final VoidCallback _cancel;

  const DebugResultsView(this._cancel, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppLocalizations.of(context)!.resultsTitle,
            style: const TextStyle(fontSize: 20.0)),
        Expanded(
          child: 
          LaunchDataView(launchData: BattlePassLaunchData(BattlePassHeader(1000, 1, "b7", "N/A"), [1000], "n/a"), speedPercentage: .5, onSave: _cancel, onCancel: _cancel,)
        ),
      ],
    );
    
    
    
  }
}
