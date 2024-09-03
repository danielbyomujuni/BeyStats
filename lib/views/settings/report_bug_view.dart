import 'dart:convert';

import 'package:bey_stats/services/bey_stats_api.dart';
import 'package:bey_stats/structs/battlepass_debug.dart';
import 'package:bey_stats/views/blank_view.dart';
import 'package:bey_stats/views/settings/battlepass_bug_modal.dart';
import 'package:bey_stats/widgets/sub_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logger/logger.dart';

class ReportBugView extends StatefulWidget {
  const ReportBugView({super.key});

  @override
  ReportBugViewState createState() => ReportBugViewState();
}

class ReportBugViewState extends State<ReportBugView> {
  String bugDescription = "";
  BattlepassDebug? debugBattleData;

  @override
  Widget build(BuildContext context) {
    var logger = Logger();

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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                        maxLines: 8, //or null
                        decoration: const InputDecoration.collapsed(
                            hintText: "Describe the bug here"),
                        onChanged: (value) {
                          setState(() {
                            bugDescription = value;
                          });
                        }),
                  )),
              const SizedBox(
                height: 4.0,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      debugBattleData == null
                          ? "Battle Pass Logs (Optional)"
                          : "Battle Pass Logs [Captured]",
                      textAlign: TextAlign.left)),
              const SizedBox(
                height: 2.0,
              ),
              SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                      onPressed: () {
                        showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return BattlepassBugModal(
                                  () => Navigator.pop(context), (debugData) {
                                setState(() {
                                  debugBattleData = debugData;
                                });
                              });
                            });
                      },
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
                      onPressed: () {
                        logger.i(bugDescription);
                        if (debugBattleData != null) {
                          logger.i(jsonEncode(debugBattleData!.toJson()));
                        }

                        BeyStatsApi.setBugReport("""{
                          "decription": "$bugDescription",
                          ${debugBattleData == null ? "" : '"battle_pass_data": "${jsonEncode(debugBattleData!.toJson())}"'}
                        }""");
                      },
                      child: const Text("Send"))),
              const SizedBox(
                height: 25.0,
              ),
            ],
          )),
    );
  }
}
