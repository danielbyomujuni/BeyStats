import 'package:bey_stats/services/inAppPurchases/in_app_purchases_service.dart';
import 'package:bey_stats/widgets/donation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'mock_app_store_connection.dart';

void main() {
  testWidgets('Creates Donation Card Widget', (WidgetTester tester) async {
    InAppPurchasesService.instance = MockAppStoreConnection();
    await tester.pumpWidget(Localizations(
        delegates: AppLocalizations.localizationsDelegates,
        locale: const Locale('en'),
        child: const DonationCard(
          amount: 5,
          color: Colors.black,
          appStoreId: "beystats_five_dollar_donation",
        )));
    expect(find.text('\$5'), findsOneWidget);
  });
}
