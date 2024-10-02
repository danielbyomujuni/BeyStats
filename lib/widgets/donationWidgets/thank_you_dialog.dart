
import 'package:flutter/material.dart';

class ThankYouDialog  {
    Future<void> show(BuildContext context, String donationType) async { // Ensure the widget is still in the widget tree
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Thank You for Supporting BeyStats'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text("Thank you for your $donationType"),
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