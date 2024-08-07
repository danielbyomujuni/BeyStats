import 'package:flutter/material.dart';

class OnboardingRemoveBey extends StatelessWidget {
  VoidCallback _goNext;
  VoidCallback _cancel;

  OnboardingRemoveBey(this._goNext, this._cancel, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Remove Bey from Launcher",
            style: TextStyle(fontSize: 20.0)),
        const Spacer(),
        const Text("Communication is unavailable when a bey is attach"),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                _goNext();
              },
              child: const Text('OK'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                _cancel();
              },
              child: const Text('Cancel'),
            )
          ],
        )
      ],
    );
  }
}
