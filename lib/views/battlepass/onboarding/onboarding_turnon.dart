import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingTurnon extends StatelessWidget {
  final VoidCallback _goNext;
  final VoidCallback _cancel;

  const OnboardingTurnon(this._goNext, this._cancel, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppLocalizations.of(context)!.turnOnBattlePassTitle,
            style: const TextStyle(fontSize: 20.0)),
        Text(AppLocalizations.of(context)!.turnOnBattlePassDescription1),
        Expanded(
            child: Card(
                color: Theme.of(context).colorScheme.inversePrimary,
                child: const Image(image: AssetImage('assets/turn_on.png')))),
        Text(AppLocalizations.of(context)!.turnOnBattlePassDescription2),
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
            child: Text(AppLocalizations.of(context)!.cancelLabel),
          ))
        ])
      ],
    );
  }
}
