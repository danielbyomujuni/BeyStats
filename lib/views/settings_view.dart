import 'package:bey_stats/views/blank_view.dart';
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
                    child: Text("Advanced", textAlign: TextAlign.left)),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SubRoot(child: BlankView()),
                    ));
                  },
                  child: const Row(
                    children: [Icon(Icons.volunteer_activism),SizedBox(width: 20), Text("Support The Developer")],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SubRoot(child: BlankView()),
                    ));
                  },
                  child: const Row(
                    children: [Icon(Icons.science),SizedBox(width: 20), Text("Experiments")],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ReportBugView(),
                    ));
                  },
                  child: const Row(
                    children: [Icon(Icons.bug_report),SizedBox(width: 20), Text("Report Bug")],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SubRoot(child: BlankView()),
                    ));
                  },
                  child: const Row(
                    children: [Icon(Icons.data_object),SizedBox(width: 20), Text("Data Mangement")],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SubRoot(child: BlankView()),
                    ));
                  },
                  child: const Row(
                    children: [Icon(Icons.gavel),SizedBox(width: 20), Text("Legal")],
                  ),
                ),
              ],
            )));
  }
}
