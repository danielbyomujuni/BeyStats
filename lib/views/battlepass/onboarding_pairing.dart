import 'package:flutter/material.dart';

class OnboardingPairing extends StatelessWidget {
  VoidCallback _goNext;
  VoidCallback _cancel;

  OnboardingPairing(this._goNext, this._cancel, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Communicate", style: TextStyle(fontSize: 20.0)),
        const Spacer(),
        const Text(
            "Press the button on the Bey Battlepass for about 1 second."),
        const Text("The LED will then flash Green and Orange in Sequence"),
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
