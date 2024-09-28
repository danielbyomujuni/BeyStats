import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseService {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late final StreamSubscription<List<PurchaseDetails>> _subscription;

  PurchaseService({required Function(PurchaseDetails) onPurchaseUpdate}) {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        for (var purchaseDetails in purchaseDetailsList) {
          if (purchaseDetails.status == PurchaseStatus.pending) {
            // Handle pending state if needed
          } else {
            onPurchaseUpdate(purchaseDetails);
            if (purchaseDetails.pendingCompletePurchase) {
              _inAppPurchase.completePurchase(purchaseDetails);
            }
          }
        }
      },
      onDone: () => _subscription.cancel(),
      onError: (error) => _subscription.cancel(),
    );
  }

  void dispose() {
    _subscription.cancel();
  }
}
