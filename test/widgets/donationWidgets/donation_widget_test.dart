import 'package:bey_stats/widgets/donationWidgets/donation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bey_stats/services/inAppPurchases/purchasable_product.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

void main() {
  testWidgets('DonationWidget displays product information correctly', (WidgetTester tester) async {
    // Arrange
    final purchasableProduct = PurchasableProduct(
        ProductDetails(
          currencyCode: "US",
          id: "bey_stats_test_product",
          title: "Test Product",
          description: "Test Description",
          price: "\$4.99",
          rawPrice: 4.99
        )
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DonationWidget(
            product: purchasableProduct,
            onPressed: () {},
            color: Colors.blue,
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('\$4.99'), findsOneWidget);
    expect(find.text('Test Product (purchased)'), findsNothing);
  });

  testWidgets('DonationWidget has a different value', (WidgetTester tester) async {
    // Arrange
    final purchasableProduct = PurchasableProduct(
        ProductDetails(
          currencyCode: "US",
          id: "bey_stats_test_product",
          title: "Test Product",
          description: "Test Description",
          price: "\$9.99",
          rawPrice: 9.99
        )
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DonationWidget(
            product: purchasableProduct,
            onPressed: () {},
            color: Colors.green,
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('\$9.99'), findsOneWidget);
  });

  testWidgets('DonationWidget calls onPressed callback when tapped', (WidgetTester tester) async {
    // Arrange
    bool wasPressed = false;
    final purchasableProduct = PurchasableProduct(
        ProductDetails(
          currencyCode: "US",
          id: "bey_stats_test_product",
          title: "Test Product",
          description: "Test Description",
          price: "\$4.99",
          rawPrice: 4.99
        )
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DonationWidget(
            product: purchasableProduct,
            onPressed: () {
              wasPressed = true;
            },
            color: Colors.red,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    // Assert
    expect(wasPressed, isTrue);
  });
}
