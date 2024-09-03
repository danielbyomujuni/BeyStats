import 'package:bey_stats/views/blank_view.dart';
import 'package:bey_stats/widgets/sub_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReportBugView extends StatefulWidget {
  const ReportBugView({super.key});

  @override
  ReportBugViewState createState() => ReportBugViewState();
}

class ReportBugViewState extends State<ReportBugView> {
  @override
  Widget build(BuildContext context) {
    return SubRoot(
      subTitle: "Bug Report",
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Bug Description", textAlign: TextAlign.left)),
              const SizedBox(
                height: 2.0,
              ),
              Card(
                  color: Theme.of(context).colorScheme.tertiary,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
                      maxLines: 8, //or null
                      decoration: InputDecoration.collapsed(
                          hintText: "Describe the bug here"),
                    ),
                  )),
              const SizedBox(
                height: 4.0,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Battle Pass Logs (Optional)",
                      textAlign: TextAlign.left)),
              const SizedBox(
                height: 2.0,
              ),
              SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                      onPressed: () {},
                      child: const Text("Connect to Battlepass"))),
              const SizedBox(
                height: 4.0,
              ),
              const Spacer(),
              const Align(
                  alignment: Alignment.centerLeft,
                  child:
                      Text("Submit to Developer", textAlign: TextAlign.left)),
              const SizedBox(
                height: 2.0,
              ),
              SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                      onPressed: () {}, child: const Text("Send"))),
              const SizedBox(
                height: 25.0,
              ),
            ],
          )),
    );
  }
}
