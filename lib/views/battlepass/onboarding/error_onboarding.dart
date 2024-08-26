import 'package:flutter/material.dart';

class ErrorOnboarding extends StatelessWidget {
  final VoidCallback _cancel;

  const ErrorOnboarding(this._cancel, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Error! (Try again)", style: TextStyle(fontSize: 20.0)),
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
                child: const Text('Close')))
      ],
    );
  }
}
