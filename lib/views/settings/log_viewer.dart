import 'package:bey_stats/services/database_instance.dart';
import 'package:bey_stats/structs/log_object.dart';
import 'package:flutter/material.dart';
import 'package:bey_stats/widgets/sub_root.dart';

class LogViewer extends StatefulWidget {
  const LogViewer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LogViewerState createState() => _LogViewerState();
}

class _LogViewerState extends State<LogViewer> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SubRoot(child: FutureBuilder<List<LogObject>>(
          future: () async {
            DatabaseInstance database = await DatabaseInstance.getInstance();
            return database.getLogs();
            }(),
          builder: (BuildContext context, AsyncSnapshot<List<LogObject>> snapshot) {
            if (!snapshot.hasData) {
              // while data is loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.separated(
    padding: const EdgeInsets.all(8),
    itemCount: snapshot.data!.length,
    itemBuilder: (BuildContext context, int index) {
      return Container(
        height: 50,
        color: Colors.amber,
        child: Center(child: Text('Entry ${snapshot.data![index]}')),
      );
    },
    separatorBuilder: (BuildContext context, int index) => const Divider(),
  );
            }
          },
        ),
    );
  }
}
