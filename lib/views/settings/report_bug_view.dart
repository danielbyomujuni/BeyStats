import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bey_stats/services/bey_stats_api.dart';
import 'package:bey_stats/structs/battlepass_debug.dart';
import 'package:bey_stats/views/settings/battlepass_bug_modal.dart';
import 'package:bey_stats/widgets/sub_root.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ReportBugView extends StatefulWidget {
  const ReportBugView({super.key});

  @override
  ReportBugViewState createState() => ReportBugViewState();
}

class ReportBugViewState extends State<ReportBugView> {
  BattlepassDebug? debugBattleData;
  final TextEditingController _bugDescription = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    var logger = Logger();

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SubRoot(
          subTitle: "Bug Report",
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Scrollbar(
                child: SingleChildScrollView(
                    child: ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            height: max(500, constraints.maxHeight - 120)),
                        child: Column(
                          children: [
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Bug Description",
                                    textAlign: TextAlign.left)),
                            const SizedBox(
                              height: 2.0,
                            ),
                            Card(
                                color: Theme.of(context).colorScheme.tertiary,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.done,
                                      maxLines: 8, //or null
                                      decoration:
                                          const InputDecoration.collapsed(
                                              hintText:
                                                  "Describe the bug here"),
                                      controller: _bugDescription,
                                      onChanged: (value) {
                                        setState(() {});
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
                                                () => Navigator.pop(context),
                                                (debugData) {
                                              setState(() {
                                                debugBattleData = debugData;
                                              });
                                            });
                                          });
                                    },
                                    child:
                                        const Text("Connect to Battlepass"))),
                            const SizedBox(
                              height: 4.0,
                            ),
                            const Spacer(),
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Submit to Developer",
                                    textAlign: TextAlign.left)),
                            const SizedBox(
                              height: 2.0,
                            ),
                            SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                    onPressed: () async {
                                      logger.i(_bugDescription.text);
                                      if (debugBattleData != null) {
                                        logger.i(jsonEncode(
                                            debugBattleData!.toJson()));
                                      }

                                      if (!context.mounted) return;

                                      var device = "";
                                      DeviceInfoPlugin deviceInfo =
                                          DeviceInfoPlugin();
                                      if (Platform.isAndroid) {
                                        var androidInfo =
                                            await deviceInfo.androidInfo;

                                        device +=
                                            '"model": "${androidInfo.model},"';
                                        device +=
                                            '"version": "${androidInfo.version.release}"';
                                      } else if (Platform.isIOS) {
                                        var iosInfo = await deviceInfo.iosInfo;

                                        device +=
                                            '"model": "${iosInfo.utsname.machine}",';
                                        device +=
                                            '"version": "${iosInfo.systemVersion}"';
                                      }
                                      PackageInfo packageInfo =
                                          await PackageInfo.fromPlatform();

                                      var id = "";
                                      try {
                                        id = await BeyStatsApi.setBugReport("""{
                            "decription": "${_bugDescription.text}",
                            "app_version": "${packageInfo.version}",
                            "device" : { ${jsonEncode(device)} },
                            ${debugBattleData == null ? "" : '"battle_pass_data": "${jsonEncode(debugBattleData!.toJson())}"'}
                          }""");
                                      } catch (err) {
                                        //TODO Handle Err
                                      }

                                      if (!context.mounted) return;
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text('Bug Report Sent'),
                                          content: Text(
                                              'Bug Report as with ID of $id'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  debugBattleData = null;
                                                  _bugDescription.clear();
                                                });
                                                Navigator.pop(context, 'OK');
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: const Text("Send"))),
                            const SizedBox(
                              height: 25.0,
                            ),
                          ],
                        ))),
              )));
    });
  }
}
