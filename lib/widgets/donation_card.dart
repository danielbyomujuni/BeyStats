import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

//beystats_five_dollar_donation
class DonationCard extends StatefulWidget {
  final int amount;
  final Color color;
  final String appStoreId;

  const DonationCard({

    required this.amount,
    required this.color,
    required this.appStoreId,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DonationCardState createState() => _DonationCardState();
}

class _DonationCardState extends State<DonationCard> {


  @override
  void initState() {
    super.initState();
  }

    @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Theme.of(context).splashColor,
        onTap: () async {
          Set<String> _product = <String>{widget.appStoreId};
          final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails(_product);
          if (response.notFoundIDs.isNotEmpty) {
            // Handle the error.
          }
          List<ProductDetails> products = response.productDetails;


          final ProductDetails productDetails = products.first; // Saved earlier from queryProductDetails().
          final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
          InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
        },
        child: Center(
          child: Text(
            '\$${widget.amount}',
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
