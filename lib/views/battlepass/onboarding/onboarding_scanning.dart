import 'package:bey_combat_logger/battlepass/beybattlepass_scanner.dart';
import 'package:bey_combat_logger/views/battlepass/battlepass_scanner.dart';
import 'package:flutter/material.dart';

class OnboardingScanning extends StatelessWidget {
  VoidCallback _goNext;
  VoidCallback _cancel;

  OnboardingScanning(this._goNext, this._cancel, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Scanning", style: TextStyle(fontSize: 20.0)),
        Expanded(child: BattlepassScanner(_goNext)),
        ElevatedButton(
            onPressed: () {
              _cancel();
            },
            child: const Text('Cancel'))
      ],
    );
  }
}
