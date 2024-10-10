import 'package:bey_stats/services/inAppPurchases/donation_counter.dart';
import 'package:bey_stats/services/inAppPurchases/donation_notifer.dart';
import 'package:bey_stats/widgets/donationWidgets/contribution_widget.dart';
import 'package:bey_stats/widgets/donationWidgets/donations_list.dart';
import 'package:bey_stats/widgets/sub_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class DeveloperSupportView extends StatelessWidget {
  const DeveloperSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return SubRoot(
        subTitle: AppLocalizations.of(context)!
                              .supportTheDevTitle,
        child: SingleChildScrollView(
            child: Column(children: [
            
          Card(
              margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              color: Theme.of(context).colorScheme.surfaceContainer,
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          const Icon(Icons.volunteer_activism, size: 50.0),
                          const SizedBox(
                            height: 7.0,
                          ),
                          Text(AppLocalizations.of(context)!
                              .supportDevDescription),
                        ],
                      )))),
          //const DonationGrid()

           ChangeNotifierProvider<DonationNotifer>(
            create: (context) => DonationNotifer(
              DonationCounter(),
            ),
            lazy: false,
            child: const Column(children: [
              ContributionWidget(),
              DonationsList()
            ],),
          ),
        ])));
  }
}
