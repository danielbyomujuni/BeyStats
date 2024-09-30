import 'package:bey_stats/app_states/experiment_state.dart';
import 'package:bey_stats/services/logger.dart';
import 'package:bey_stats/widgets/sub_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExperimentsView extends StatefulWidget {
  const ExperimentsView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ExperimentsViewState createState() => _ExperimentsViewState();
}

class _ExperimentsViewState extends State<ExperimentsView> {
  @override
  Widget build(BuildContext context) {
    return SubRoot(
      subTitle: "Experiments",
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const Icon(Icons.science, size: 50.0),
                    const SizedBox(height: 7.0),
                    Text(AppLocalizations.of(context)!.experimentsDescription),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<ExperimentState, Map<String, bool>>(
              builder: (context, experiment) => ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: ExperimentState.getExperiments().length,
                itemBuilder: (listContext, index) {
                  final item = ExperimentState.getExperiments()[index];
                  return Card(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    child: ListTile(
                      key: item.toKey(),
                      title: Text(item.getName()),
                      trailing: Switch(
                        value: experiment[item.getID()] ?? false,
                        activeColor: Theme.of(listContext).colorScheme.primary,
                        onChanged: (bool value) {
                          Logger.info("Set ${item.getName()} to $value");
                          item.setExperimentState(context, value);
                          setState(() {}); //Refresh the View
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
