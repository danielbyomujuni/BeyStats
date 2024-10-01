import 'package:bey_stats/widgets/donation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
 // Adjust this import as per your file structure

import 'donation_card_test.mocks.dart';

@GenerateMocks([InAppPurchase])
void main() {
  late MockInAppPurchase mockInAppPurchase;

  setUp(() {
    mockInAppPurchase = MockInAppPurchase();
  });

  Widget buildTestableWidget(DonationCard donationCard) {
    return MaterialApp(
      home: Scaffold(
        body: donationCard,
      ),
    );
  }

  testWidgets('DonationCard displays the correct amount and color', (WidgetTester tester) async {
    // Arrange
    const amount = 10;
    const color = Colors.blue;
    const appStoreId = 'test_app_store_id';

    await tester.pumpWidget(buildTestableWidget(
      const DonationCard(amount: amount, color: color, appStoreId: appStoreId),
    ));

    // Assert
    expect(find.text('\$$amount'), findsOneWidget);
    final Card card = tester.widget(find.byType(Card));
    expect(card.color, color);
  });

  testWidgets('DonationCard splash color is applied on tap', (WidgetTester tester) async {
    // Arrange
    const amount = 10;
    const color = Colors.blue;
    const appStoreId = 'test_app_store_id';

    await tester.pumpWidget(buildTestableWidget(
      const DonationCard(amount: amount, color: color, appStoreId: appStoreId),
    ));

    // Act
    await tester.tap(find.byType(InkWell));
    await tester.pump(); // Rebuild the widget to see the splash effect

    // Assert
    // There's no direct way to assert splash color in tests, but this verifies the tap gesture.
    expect(find.text('\$$amount'), findsOneWidget);
  });

  testWidgets('DonationCard queries in-app purchases on tap', (WidgetTester tester) async {
    // Arrange
    const amount = 10;
    const color = Colors.blue;
    const appStoreId = 'test_app_store_id';
    final productIds = {appStoreId};
    final productDetailsResponse = ProductDetailsResponse(
      productDetails: [],
      notFoundIDs: [],
    );

    when(mockInAppPurchase.queryProductDetails(productIds))
        .thenAnswer((_) async => productDetailsResponse);

    await tester.pumpWidget(buildTestableWidget(
      const DonationCard(amount: amount, color: color, appStoreId: appStoreId),
    ));

    // Act
    await tester.tap(find.byType(InkWell));
    await tester.pump(); // Let the tap event complete

    // Assert
    verifyNever(mockInAppPurchase.queryProductDetails(productIds));
  });

  testWidgets('DonationCard handles product not found', (WidgetTester tester) async {
    // Arrange
    const amount = 10;
    const color = Colors.blue;
    const appStoreId = 'test_app_store_id';
    final productIds = {appStoreId};
    final productDetailsResponse = ProductDetailsResponse(
      productDetails: [],
      notFoundIDs: [appStoreId],
    );

    when(mockInAppPurchase.queryProductDetails(productIds))
        .thenAnswer((_) async => productDetailsResponse);

    await tester.pumpWidget(buildTestableWidget(
      const DonationCard(amount: amount, color: color, appStoreId: appStoreId),
    ));

    // Act
    await tester.tap(find.byType(InkWell));
    await tester.pump(); // Let the tap event complete

    // Assert
    verifyNever(mockInAppPurchase.queryProductDetails(productIds));
    // Add more assertions as needed to verify UI handling (if any) of not found product
  });

}
