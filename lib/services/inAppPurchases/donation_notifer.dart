import 'dart:async';

import 'package:bey_stats/services/inAppPurchases/donation_counter.dart';
import 'package:bey_stats/services/inAppPurchases/donation_options.dart';
import 'package:bey_stats/services/inAppPurchases/in_app_purchases_service.dart';
import 'package:bey_stats/services/inAppPurchases/purchasable_product.dart';
import 'package:bey_stats/services/inAppPurchases/store_state.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class DonationNotifer extends ChangeNotifier {
  DonationCounter dontaionAmount;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final iapConnection = InAppPurchasesService.instance;
  List<PurchasableProduct> products = [];
  StoreState storeState = StoreState.loading;

  DonationNotifer(this.dontaionAmount) {
    final purchaseUpdated = iapConnection.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: _updateStreamOnDone,
      onError: _updateStreamOnError,
    );
    loadPurchases();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> buy(PurchasableProduct product) async {
    final purchaseParam = PurchaseParam(productDetails: product.productDetails);
    
    //Everything is consumable for adding anything else
    // https://codelabs.developers.google.com/codelabs/flutter-in-app-purchases#7
    await iapConnection.buyConsumable(purchaseParam: purchaseParam);
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      await _handlePurchase(purchaseDetails);
    }
    notifyListeners();
  }

  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.purchased) {
      for (var option in DonationOptions.getOptions()) {
        if (purchaseDetails.productID == option.getID()) {
          dontaionAmount.add(option.getValue());
          break;
        }
      }
    }

    if (purchaseDetails.pendingCompletePurchase) {
      await iapConnection.completePurchase(purchaseDetails);
    }
  }

  void _updateStreamOnDone() {
    _subscription.cancel();
  }

  void _updateStreamOnError(dynamic error) {
    //Handle error here
  }

  Future<void> loadPurchases() async {
    final available = await iapConnection.isAvailable();
    if (!available) {
      storeState = StoreState.notAvailable;
      notifyListeners();
      return;
    }
    final ids = DonationOptions.getSetOfID();
    final response = await iapConnection.queryProductDetails(ids);
    for (var element in response.notFoundIDs) {
      debugPrint('Purchase $element not found');
    }
    products =
        response.productDetails.map((e) => PurchasableProduct(e)).toList();
    storeState = StoreState.available;
    notifyListeners();
  }
}
