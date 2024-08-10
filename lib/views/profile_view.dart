import 'package:bey_combat_logger/battlepass/database_instance.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        ElevatedButton(
            onPressed: () async {
              await (await DatabaseInstance.getInstance()).clearDatabase();
            },
            child: const Text("Delete Data"))
      ],
    );
  }
}
