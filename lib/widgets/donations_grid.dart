import 'package:flutter/material.dart';

class DonationGrid extends StatelessWidget {
  const DonationGrid({super.key});

  Widget buildDonationCard(int amount, Color color, VoidCallback onTap, BuildContext context) {
    return Card(
        color: color,
        clipBehavior: Clip.hardEdge,
        child: InkWell( 
        splashColor: Theme.of(context).splashColor,
        onTap: onTap,
        child: Center(
          child: Text(
            '\$$amount',
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 2 / 1,
            child: buildDonationCard(5, Theme.of(context).colorScheme.primary, () {
              // Handle $5 donation tap
            },context),
          ),
          AspectRatio(
            aspectRatio: 2 / 1,
            child: Row(
              children: [
                Expanded(
                  child: buildDonationCard(10, Theme.of(context).colorScheme.secondary, () {
                    // Handle $10 donation tap
                  },context),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: buildDonationCard(25, Theme.of(context).colorScheme.secondary, () {
                    // Handle $25 donation tap
                  },context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
