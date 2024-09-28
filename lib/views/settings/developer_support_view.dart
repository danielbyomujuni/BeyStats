import 'package:bey_stats/widgets/donations_grid.dart';
import 'package:bey_stats/widgets/sub_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeveloperSupportView extends StatelessWidget {
  const DeveloperSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return SubRoot(
      subTitle: "Support the Dev",
      child: Column( children:[
              Card(
                margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                color: Theme.of(context).colorScheme.surfaceContainer,
                child: 
                Center(child:
                Padding(padding: const EdgeInsets.all(10.0), child:
                Column(
                  children: [
                    const Icon(Icons.volunteer_activism,size: 50.0),
                    const SizedBox(height: 7.0,),
                    Text(AppLocalizations.of(context)!.supportDevDescription),
                  ],
                )))
              ),
              const DonationGrid()
              
            
            ])
          );
  }
}