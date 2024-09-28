import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class DonationCard extends StatefulWidget {
  final int amount;
  final Color color;
  final String appStoreId;

  const DonationCard({
    super.key,
    required this.amount,
    required this.color,
    required this.appStoreId,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DonationCardState createState() => _DonationCardState();
}

class _DonationCardState extends State<DonationCard> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Theme.of(context).splashColor,
        onTap: _handleTap,
        child: Center(
          child: Text(
            '\$${widget.amount}',
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _handleTap() async {
    final Set<String> productIds = {widget.appStoreId};
    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(productIds);

    if (response.notFoundIDs.isNotEmpty) {
      // Handle the error if the product is not found
      return;
    }

    if (response.productDetails.isNotEmpty) {
      final ProductDetails productDetails = response.productDetails.first;
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
      
      try {
        await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
      } catch (e) {
        // Handle purchase error
      }
    }
  }
}
