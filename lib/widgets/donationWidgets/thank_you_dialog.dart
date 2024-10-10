import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThankYouDialog  {
    Future<void> show(BuildContext context, String donationType) async { // Ensure the widget is still in the widget tree
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.thankYouForYouSupport),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text("${AppLocalizations.of(context)!.thankYouForDonation} $donationType"),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
  
}