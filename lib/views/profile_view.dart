
import 'package:bey_stats/services/database/database_core.dart';
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
              await (await DatabaseCore.getInstance()).clearTables();
            },
            child: const Text("Delete Data"))
      ],
    );
  }
}
