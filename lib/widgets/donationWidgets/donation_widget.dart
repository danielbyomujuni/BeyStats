import 'package:bey_stats/services/inAppPurchases/donation_status.dart';
import 'package:bey_stats/services/inAppPurchases/purchasable_product.dart';
import 'package:flutter/material.dart';

class DonationWidget extends StatelessWidget {
  final PurchasableProduct product;
  final VoidCallback onPressed;

  const DonationWidget({
    super.key, 
    required this.product,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var title = product.title;
    if (product.status == DonationStatus.purchased) {
      title += ' (purchased)';
    }
    return InkWell(
        onTap: onPressed,
        child: ListTile(
          title: Text(
            title,
          ),
          subtitle: Text(product.description),
          trailing: Text(_trailing()),
        ));
  }

  String _trailing() {
    return switch (product.status) {
      DonationStatus.purchasable => product.price,
      DonationStatus.purchased => 'purchased',
      DonationStatus.pending => 'buying...'
    };
  }
}