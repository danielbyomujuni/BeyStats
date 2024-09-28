import 'dart:async';

import 'package:bey_stats/services/logger.dart';
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

  final Map<String, String> products = {"beystats_five_dollar_donation":"\$5 Donation","beystats_ten_dollar_donation":"\$10 Donation","beystats_twenty_five_dollar_donation":"\$25 Donation"};

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  // You can add state variables here if needed
  @override
  void initState() {
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      _subscription.cancel();
    }) as StreamSubscription<List<PurchaseDetails>>;

    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    // ignore: avoid_function_literals_in_foreach_calls
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        //_showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          //_handleError(purchaseDetails.error!);
          return;
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          Logger.debug(purchaseDetails.status.name);
          _showMyDialog(products[purchaseDetails.productID]!);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    });
  }

  Future<void> _showMyDialog(String donationType) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thank you For Supporting Beystats'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Thank you for you $donationType"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
