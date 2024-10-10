import 'package:bey_stats/app_states/experiment_state.dart';
import 'package:bey_stats/services/datamanager.dart';
import 'package:bey_stats/services/logger.dart';
//import 'package:bey_stats/services/logger.dart';
import 'package:bey_stats/widgets/alert.dart';
import 'package:bey_stats/widgets/sub_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DataManagementView extends StatelessWidget {
  const DataManagementView({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SubRoot(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            child: Column(children: [
              Card(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: Center(
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              const Icon(Icons.data_object, size: 50.0),
                              const SizedBox(
                                height: 7.0,
                              ),
                              Text(AppLocalizations.of(context)!
                                  .dataManagementDescription),
                            ],
                          )))),
              Card(
                  clipBehavior: Clip.hardEdge,
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: InkWell(
                      splashColor: Theme.of(context).splashColor,
                      onTap: () {
                        Datamanager().downloadDatabase();
                      },
                      child: ListTile(
                        title: Text(AppLocalizations.of(context)!.backUpDataLabel),
                        leading: const Icon(Icons.download),
                      ))),
              Card(
                  clipBehavior: Clip.hardEdge,
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: InkWell(
                      splashColor: Theme.of(context).splashColor,
                      onTap: () async {
                        try {
                          await Datamanager().getNewDatabase();
                          if (!context.mounted) {
                            return;
                          }
                          Alert().confirmDialog(context,
                              title: AppLocalizations.of(context)!.areYouSure,
                              description:
                                  AppLocalizations.of(context)!.warningDataOverwrite,
                              onSuccess: () async {
                            await Datamanager().saveNewDatabase();
                            if (context.mounted) {
                              ExperimentState.reloadExperiments(context);
                            }
                          });
                        } catch (e) {
                          Logger.error(e.toString());
                        }
                      },
                      child: const ListTile(
                        title: Text("Restore Data"),
                        leading: Icon(Icons.publish),
                      ))),
              /*Card(
                  clipBehavior: Clip.hardEdge,
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: InkWell(
                      splashColor: Theme.of(context).splashColor,
                      onTap: () {
                        Alert().showMyDialog(context);
                      },
                      child: const ListTile(
                        title: Text("Delete Data"),
                        leading: Icon(Icons.delete),
                      )))*/
            ])));
  }
}
