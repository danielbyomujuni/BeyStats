import 'dart:collection';

import 'package:bey_stats/services/inAppPurchases/donation_notifer.dart';
import 'package:bey_stats/services/inAppPurchases/donation_status.dart';
import 'package:bey_stats/services/logger.dart';
import 'package:bey_stats/widgets/donationWidgets/donation_widget.dart';
import 'package:bey_stats/widgets/donationWidgets/thank_you_dialog.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

class DonationsList extends StatelessWidget {
  const DonationsList({super.key});

  @override
  Widget build(BuildContext context) {
    var purchases = context.watch<DonationNotifer>();
    var products = purchases.products;

    List<Widget> buttons = [];

    for (var index = 0; index < products.length; index++) {
      if ((index % 3) == 0 || index == products.length - 1) {
        buttons.add(AspectRatio(
            aspectRatio: 2 / 1,
            child: DonationWidget(
                product: products[index],
                onPressed: () {
                  purchases.setOnPurchaseEvent(() {
                    Logger.debug("Purchase Complete");
                    ThankYouDialog().show(context, products[index].title);
                  });
                  purchases.buy(products[index]);
                })));
      } else {
        buttons.add(const SizedBox(height: 10));
        buttons.add(
          AspectRatio(
              aspectRatio: 2 / 1,
              child: Row(
                children: [
                  Expanded(
                      child: DonationWidget(
                          color: Theme.of(context).colorScheme.secondary,
                          product: products[index+ 1],
                          onPressed: () {
                            purchases.setOnPurchaseEvent(() {
                              Logger.debug("Purchase Complete");
                              ThankYouDialog()
                                  .show(context, products[index+ 1].title);
                            });
                            purchases.buy(products[index+ 1]);
                          })),
                  const SizedBox(width: 10),
                  Expanded(
                      child: DonationWidget(
                          color: Theme.of(context).colorScheme.secondary,
                          product: products[index],
                          onPressed: () {
                            purchases.setOnPurchaseEvent(() {
                              Logger.debug("Purchase Complete");
                              ThankYouDialog()
                                  .show(context, products[index].title);
                            });
                            purchases.buy(products[index]);
                          }))
                ],
              )),
        );
        index++;
      }
    }

    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: buttons, //buttons,
        ));
  }
}
