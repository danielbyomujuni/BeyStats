import 'dart:async';

import 'package:bey_stats/services/database/donation_database.dart';
import 'package:bey_stats/services/inAppPurchases/donation_counter.dart';
import 'package:bey_stats/services/inAppPurchases/donation_options.dart';
import 'package:bey_stats/services/inAppPurchases/in_app_purchases_service.dart';
import 'package:bey_stats/services/inAppPurchases/purchasable_product.dart';
import 'package:bey_stats/services/inAppPurchases/store_state.dart';
import 'package:bey_stats/services/logger.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class DonationNotifer extends ChangeNotifier {
  DonationCounter dontaionAmount;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final iapConnection = InAppPurchasesService.instance;
  List<PurchasableProduct> products = [];
  StoreState storeState = StoreState.loading;
  void Function()? purchaseEvent;

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
    Logger.debug("Buying Product");
    await iapConnection.buyConsumable(purchaseParam: purchaseParam);
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      await _handlePurchase(purchaseDetails);
    }
  }

  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
      double currentProductPrice = 0.0;

      if (purchaseDetails.status == PurchaseStatus.purchased) {
        Logger.debug("Checking the order");
        for (var option in DonationOptions.getOptions()) {
          if (purchaseDetails.productID == option.getID()) {
            dontaionAmount.add(option.getValue());
            currentProductPrice = option.getValue();
            DonationDatabase db = await DonationDatabase.getInstance();
            db.addDonation(currentProductPrice);
            purchaseEvent!();
            break;
          }
        }
      }
      if (purchaseDetails.pendingCompletePurchase) {
        Logger.debug("Trying to Purchase");
        await iapConnection.completePurchase(purchaseDetails);
      }
      notifyListeners();
  }

  void _updateStreamOnDone() {
    Logger.debug("Stream is Done");
    _subscription.cancel();
  }

  void _updateStreamOnError(dynamic error) {
    //Handle error here
    Logger.error("error handler called: $error");
    _subscription.cancel();
  }

  Future<void> loadPurchases() async {
    final available = await iapConnection.isAvailable();
    if (!available) {
      storeState = StoreState.notAvailable;
      notifyListeners();
      return;
    }
    final ids = DonationOptions.getSetOfID();
    await iapConnection.isAvailable();
    final response = await iapConnection.queryProductDetails(ids);
    for (var element in response.notFoundIDs) {
      debugPrint('Purchase $element not found');
    }
    products =
        response.productDetails.map((e) => PurchasableProduct(e)).toList();
    products.sort((a, b) => b.title.compareTo(a.title));
    storeState = StoreState.available;
    notifyListeners();
  }

  void setOnPurchaseEvent(void Function() event) {
    purchaseEvent = event;
  }
  
}
