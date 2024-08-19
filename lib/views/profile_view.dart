import 'package:bey_stats/battlepass/database_instance.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

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
