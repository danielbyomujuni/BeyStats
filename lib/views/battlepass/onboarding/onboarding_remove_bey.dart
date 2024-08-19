import 'package:flutter/material.dart';

class OnboardingRemoveBey extends StatelessWidget {
  final VoidCallback _goNext;
  final VoidCallback _cancel;

  const OnboardingRemoveBey(this._goNext, this._cancel, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Remove Bey from Launcher",
            style: TextStyle(fontSize: 20.0)),
        const Spacer(),
        const Text("Communication is unavailable when a bey is attach"),
        Row(children: [
          Expanded(
              child: FilledButton(
            onPressed: () async {
              _goNext();
            },
            child: const Text('OK'),
          )),
          const SizedBox(width: 15.0),
          Expanded(
              child: OutlinedButton(
            onPressed: () {
              _cancel();
            },
            child: const Text('Cancel'),
          ))
        ])
      ],
    );
  }
}
