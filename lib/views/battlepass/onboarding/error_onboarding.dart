import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorOnboarding extends StatelessWidget {
  final VoidCallback _cancel;

  const ErrorOnboarding(this._cancel, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppLocalizations.of(context)!.errorTryAgain,
            style: const TextStyle(fontSize: 20.0)),
        Expanded(
            child: FittedBox(
                fit: BoxFit.fill,
                child: Icon(
                  Icons.error,
                  color: Theme.of(context).colorScheme.error,
                ))),
        SizedBox(
            width: double.infinity,
            child: OutlinedButton(
                onPressed: () {
                  _cancel();
                },
                child: Text(AppLocalizations.of(context)!.close_label)))
      ],
    );
  }
}
