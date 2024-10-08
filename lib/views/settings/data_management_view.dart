import 'package:bey_stats/services/database/datamanager.dart';
import 'package:bey_stats/services/logger.dart';
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
                      child: const ListTile(
                        title: Text("Back-Up Data"),
                        leading: Icon(Icons.download),
                      ))),
              Card(
                  clipBehavior: Clip.hardEdge,
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: InkWell(
                      splashColor: Theme.of(context).splashColor,
                      onTap: () {
                        _showMyDialog(context);
                      },
                      child: const ListTile(
                        title: Text("Restore Data"),
                        leading: Icon(Icons.publish),
                      ))),
              Card(
                  clipBehavior: Clip.hardEdge,
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: InkWell(
                      splashColor: Theme.of(context).splashColor,
                      onTap: () {
                        _showMyDialog(context);
                      },
                      child: const ListTile(
                        title: Text("Delete Data"),
                        leading: Icon(Icons.delete),
                      )))
                    
            ])));
  }

  Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Sorry'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This functionality is not implemented yet'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
}
