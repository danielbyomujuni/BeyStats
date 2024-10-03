import 'package:bey_stats/services/inAppPurchases/purchasable_product.dart';
import 'package:flutter/material.dart';

class DonationWidget extends StatelessWidget {
  final PurchasableProduct product;
  final VoidCallback onPressed;
  final Color? color;

  const DonationWidget({
    super.key, 
    required this.product,
    required this.onPressed, 
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return  Card(
      color: color ?? Theme.of(context).colorScheme.primary,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Theme.of(context).splashColor,
        onTap: onPressed,
        child: Center(
          child: Text(
            product.price,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}