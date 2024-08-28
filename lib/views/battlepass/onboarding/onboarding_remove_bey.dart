import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingRemoveBey extends StatelessWidget {
  final VoidCallback _goNext;
  final VoidCallback _cancel;

  const OnboardingRemoveBey(this._goNext, this._cancel, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppLocalizations.of(context)!.removeBeyTitle,
            style: const TextStyle(fontSize: 20.0)),
        Expanded(
            child: Card(
                color: Theme.of(context).colorScheme.inversePrimary,
                child:
                    const Image(image: AssetImage('assets/remove_bey.png')))),
        Text(AppLocalizations.of(context)!.removeBeyDescription),
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
