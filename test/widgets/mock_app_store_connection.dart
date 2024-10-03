import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_platform_interface/src/in_app_purchase_platform_addition.dart';

class MockAppStoreConnection implements InAppPurchase {
  @override
  Future<bool> buyConsumable(
      {required PurchaseParam purchaseParam, bool autoConsume = true}) {
    return Future.value(false);
  }

  @override
  Future<bool> buyNonConsumable({required PurchaseParam purchaseParam}) {
    return Future.value(false);
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchase) {
    return Future.value();
  }

  @override
  Future<bool> isAvailable() {
    return Future.value(false);
  }

  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> identifiers) {
    return Future.value(ProductDetailsResponse(
      productDetails: [],
      notFoundIDs: [],
    ));
  }

  @override
  T getPlatformAddition<T extends InAppPurchasePlatformAddition?>() {
    // TODO: implement getPlatformAddition
    throw UnimplementedError();
  }

  @override
  Stream<List<PurchaseDetails>> get purchaseStream =>
      Stream.value(<PurchaseDetails>[]);

  @override
  Future<void> restorePurchases({String? applicationUserName}) {
    // TODO: implement restorePurchases
    throw UnimplementedError();
  }

  @override
  Future<String> countryCode() {
    // TODO: implement countryCode
    throw UnimplementedError();
  }
}