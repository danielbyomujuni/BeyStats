import 'package:bey_stats/services/inAppPurchases/donation_notifer.dart';
import 'package:bey_stats/widgets/donationWidgets/donation_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var purchases = context.watch<DonationNotifer>();
    var products = purchases.products;
    return Column(
      children: products
          .map((product) => DonationWidget(
              product: product,
              onPressed: () {
                purchases.buy(product);
              }))
          .toList(),
    );
  }
}