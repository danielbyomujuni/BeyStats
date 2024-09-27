import 'package:bey_stats/views/blank_view.dart';
import 'package:bey_stats/views/settings/legal_view.dart';
import 'package:bey_stats/views/settings/bugreporting/report_bug_view.dart';
import 'package:bey_stats/widgets/sub_root.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final options = [
      const _SettingsOption(
        label: "Support The Developer",
        icon: Icons.volunteer_activism,
        destination: SubRoot(child: BlankView()),
      ),
      const _SettingsOption(
        label: "Experiments",
        icon: Icons.science,
        destination: SubRoot(child: BlankView()),
      ),
      const _SettingsOption(
        label: "Report Bug",
        icon: Icons.bug_report,
        destination: ReportBugView(),
      ),
      const _SettingsOption(
        label: "Data Management",
        icon: Icons.data_object,
        destination: SubRoot(child: BlankView()),
      ),
      const _SettingsOption(
        label: "Legal",
        icon: Icons.gavel,
        destination: LegalView(),
      ),
    ];

    return SubRoot(
      subTitle: "Settings",
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Advanced", textAlign: TextAlign.left),
            ...options.map((option) => OutlinedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => option.destination),
              ),
              child: Row(
                children: [Icon(option.icon), const SizedBox(width: 20), Text(option.label)],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _SettingsOption {
  final String label;
  final IconData icon;
  final Widget destination;

  const _SettingsOption({
    required this.label,
    required this.icon,
    required this.destination,
  });
}
