import 'package:bey_stats/views/blank_view.dart';
import 'package:bey_stats/widgets/sub_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExperimentsView extends StatelessWidget {
  const ExperimentsView({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SubRoot(subTitle: "Experiments", child: 
    Column( children:[
              Card(
                margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                color: Theme.of(context).colorScheme.surfaceContainer,
                child: 
                Center(child:
                Padding(padding: const EdgeInsets.all(10.0), child:
                Column(
                  children: [
                    const Icon(Icons.science,size: 50.0),
                    const SizedBox(height: 7.0,),
                    Text(AppLocalizations.of(context)!.experimentsDescription),
                  ],
                )))
              ), 
              const BlankView()      
            ]),);
  }
}
