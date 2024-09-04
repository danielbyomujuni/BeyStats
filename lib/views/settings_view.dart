import 'package:bey_stats/views/settings/report_bug_view.dart';
import 'package:bey_stats/widgets/sub_root.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SubRoot(
        subTitle: "Settings",
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Debug", textAlign: TextAlign.left)),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ReportBugView(),
                    ));
                  },
                  child: const Row(
                    children: [Icon(Icons.bug_report), Text("Report Bug")],
                  ),
                )
              ],
            )));
  }
}
