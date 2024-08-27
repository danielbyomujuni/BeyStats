import 'package:bey_stats/views/battlepass/battlepass_scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingScanning extends StatelessWidget {
  final VoidCallback _goNext;
  final VoidCallback _cancel;
  final VoidCallback _error;

  const OnboardingScanning(this._goNext, this._cancel, this._error,
      {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppLocalizations.of(context)!.scanningTitle,
            style: const TextStyle(fontSize: 20.0)),
        Expanded(child: BattlepassScanner(_goNext)),
        kDebugMode
            ? Row(
                children: [
                  Expanded(
                      child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            foregroundColor:
                                Theme.of(context).colorScheme.onError,
                          ),
                          onPressed: () {
                            _error();
                          },
                          child:
                              Text(AppLocalizations.of(context)!.errorLabel))),
                  const SizedBox(width: 10.0),
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () {
                            _cancel();
                          },
                          child:
                              Text(AppLocalizations.of(context)!.cancelLabel)))
                ],
              )
            : SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    onPressed: () {
                      _cancel();
                    },
                    child: Text(AppLocalizations.of(context)!.cancelLabel)))
      ],
    );
  }
}
