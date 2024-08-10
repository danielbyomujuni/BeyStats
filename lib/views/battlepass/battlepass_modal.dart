import 'package:bey_combat_logger/views/battlepass/onboarding/battlepass_onboarding.dart';
import 'package:bey_combat_logger/views/battlepass/battlepass_scanner.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class BattlepassModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 900,
                  padding: const EdgeInsets.fromLTRB(20, 13, 20, 28),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                            child: BattlepassOnboarding(
                                () => Navigator.pop(context)))
                      ],
                    ),
                  ),
                );
              });
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.sync,
          size: 25,
        )
        //params
        );
  }
}
