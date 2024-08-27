import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingPairing extends StatelessWidget {
  final VoidCallback _goNext;
  final VoidCallback _cancel;

  const OnboardingPairing(this._goNext, this._cancel, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppLocalizations.of(context)!.comunicateTitle,
            style: const TextStyle(fontSize: 20.0)),
        Expanded(
            child: Card(
                color: Theme.of(context).colorScheme.inversePrimary,
                child: const Image(image: AssetImage('assets/pair.png')))),
        Text(AppLocalizations.of(context)!.pairBattlePass_1),
        Text(AppLocalizations.of(context)!.pairBattlePass_2),
        Row(children: [
          Expanded(
              child: FilledButton(
            onPressed: () async {
              _goNext();
            },
            child: Text(AppLocalizations.of(context)!.okLabel),
          )),
          const SizedBox(width: 15.0),
          Expanded(
              child: OutlinedButton(
            onPressed: () {
              _cancel();
            },
            child: Text(AppLocalizations.of(context)!.close_label),
          ))
        ])
      ],
    );
  }
}
