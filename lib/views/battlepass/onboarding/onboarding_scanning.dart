import 'package:bey_stats/views/battlepass/battlepass_scanner.dart';
import 'package:flutter/material.dart';

class OnboardingScanning extends StatelessWidget {
  final VoidCallback _goNext;
  final VoidCallback _cancel;

  const OnboardingScanning(this._goNext, this._cancel, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Scanning", style: TextStyle(fontSize: 20.0)),
        Expanded(child: BattlepassScanner(_goNext)),
        SizedBox(
            width: double.infinity,
            child: OutlinedButton(
                onPressed: () {
                  _cancel();
                },
                child: const Text('Cancel')))
      ],
    );
  }
}
