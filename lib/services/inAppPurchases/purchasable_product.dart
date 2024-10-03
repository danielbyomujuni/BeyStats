import 'package:bey_stats/services/inAppPurchases/donation_status.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchasableProduct {
  String get id => productDetails.id;
  String get title => productDetails.title;
  String get description => productDetails.description;
  String get price => productDetails.price;
  DonationStatus status;
  ProductDetails productDetails;

  PurchasableProduct(this.productDetails) : status = DonationStatus.purchasable;
}