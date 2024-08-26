import 'package:flutter/material.dart';

class OnboardingTurnon extends StatelessWidget {
  final VoidCallback _goNext;
  final VoidCallback _cancel;

  const OnboardingTurnon(this._goNext, this._cancel, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Turn on the Battlepass", style: TextStyle(fontSize: 20.0)),
        const Text(
            "Press the button on the Bey Battlepass for about 1 second."),
        Expanded(
            child: Card(
                color: Theme.of(context).colorScheme.inversePrimary,
                child: const Image(image: AssetImage('assets/turn_on.png')))),
        const Text("The LED will glow green"),
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
