import 'package:bey_stats/widgets/donation_card.dart';
import 'package:flutter/material.dart';

class DonationGrid extends StatelessWidget {
  const DonationGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 2 / 1,
            child: DonationCard(amount: 5, color: Theme.of(context).colorScheme.primary, appStoreId: "beystats_five_dollar_donation"),
          ),
          AspectRatio(
            aspectRatio: 2 / 1,
            child: Row(
              children: [
                Expanded(
                  child: DonationCard(amount: 10, color: Theme.of(context).colorScheme.secondary, appStoreId: "beystats_five_dollar_donation"),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DonationCard(amount: 25, color: Theme.of(context).colorScheme.secondary, appStoreId: "beystats_five_dollar_donation"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
