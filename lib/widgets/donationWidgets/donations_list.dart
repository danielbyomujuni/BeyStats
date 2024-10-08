import 'package:bey_stats/services/inAppPurchases/donation_notifer.dart';
import 'package:bey_stats/services/inAppPurchases/purchasable_product.dart';
import 'package:bey_stats/services/logger.dart';
import 'package:bey_stats/widgets/donationWidgets/donation_widget.dart';
import 'package:bey_stats/widgets/donationWidgets/thank_you_dialog.dart';
import 'package:flutter/material.dart';
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
        Logger.debug("${products[index].price}:${products[index].title}");
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
        PurchasableProduct firstProduct = products[index + 1];
        PurchasableProduct secondProduct = products[index];

        Logger.debug("fir: ${firstProduct.price}:${firstProduct.title}");
        Logger.debug("sec: ${secondProduct.price}:${secondProduct.title}");
        buttons.add(const SizedBox(height: 10));
        buttons.add(
          AspectRatio(
              aspectRatio: 2 / 1,
              child: Row(
                children: [
                  Expanded(
                      child: DonationWidget(
                          color: Theme.of(context).colorScheme.secondary,
                          product: firstProduct,
                          onPressed: () {
                            purchases.setOnPurchaseEvent(() {
                              Logger.debug("Purchase Complete");
                              ThankYouDialog()
                                  .show(context, firstProduct.title);
                            });
                            Logger.debug("Buying: ${firstProduct.title}");
                            purchases.buy(firstProduct);
                          })),
                  const SizedBox(width: 10),
                  Expanded(
                      child: DonationWidget(
                          color: Theme.of(context).colorScheme.secondary,
                          product: secondProduct,
                          onPressed: () {
                            purchases.setOnPurchaseEvent(() {
                              Logger.debug("Purchase Complete");
                              ThankYouDialog()
                                  .show(context, secondProduct.title);
                            });
                            Logger.debug("Buying: ${secondProduct.price}");
                            purchases.buy(secondProduct);
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
