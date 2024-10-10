import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class BlankView extends StatelessWidget {
  const BlankView({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.nothingHere,
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontSize: 18,
        ),
      ),
    );
  }
}
