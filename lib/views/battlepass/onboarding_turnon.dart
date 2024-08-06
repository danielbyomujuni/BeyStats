import 'package:flutter/material.dart';

class OnboardingTurnon extends StatelessWidget {
  VoidCallback _goNext;
  VoidCallback _cancel;

  OnboardingTurnon(this._goNext, this._cancel, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Turn on the Battlepass", style: TextStyle(fontSize: 20.0)),
        const Text(
            "Press the button on the Bey Battlepass for about 1 second."),
        const Spacer(),
        const Text("The LED will glow green"),
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
