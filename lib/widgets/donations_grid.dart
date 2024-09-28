import 'dart:async';
import 'package:bey_stats/services/logger.dart';
import 'package:bey_stats/services/purchase_service.dart';
import 'package:bey_stats/widgets/donation_card.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class DonationGrid extends StatefulWidget {
  const DonationGrid({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DonationGridState createState() => _DonationGridState();
}

class _DonationGridState extends State<DonationGrid> {
  final Map<String, String> products = {
    "beystats_five_dollar_donation": "\$5 Donation",
    "beystats_ten_dollar_donation": "\$10 Donation",
    "beystats_twenty_five_dollar_donation": "\$25 Donation"
  };

  late final PurchaseService _purchaseService;

  @override
  void initState() {
    super.initState();
    _purchaseService = PurchaseService(
      onPurchaseUpdate: _onPurchaseUpdated,
    );
  }

  @override
  void dispose() {
    _purchaseService.dispose();
    super.dispose();
  }

  void _onPurchaseUpdated(PurchaseDetails purchaseDetails) {
    if (purchaseDetails.status == PurchaseStatus.purchased ||
        purchaseDetails.status == PurchaseStatus.restored) {
      Logger.debug(purchaseDetails.status.name);
      _showThankYouDialog(products[purchaseDetails.productID]!);
    }
  }

  Future<void> _showThankYouDialog(String donationType) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thank You for Supporting BeyStats'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Thank you for your $donationType"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
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
            child: DonationCard(
              amount: 5,
              color: Theme.of(context).colorScheme.primary,
              appStoreId: "beystats_five_dollar_donation",
            ),
          ),
          AspectRatio(
            aspectRatio: 2 / 1,
            child: Row(
              children: [
                Expanded(
                  child: DonationCard(
                    amount: 10,
                    color: Theme.of(context).colorScheme.secondary,
                    appStoreId: "beystats_ten_dollar_donation",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DonationCard(
                    amount: 25,
                    color: Theme.of(context).colorScheme.secondary,
                    appStoreId: "beystats_twenty_five_dollar_donation",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
