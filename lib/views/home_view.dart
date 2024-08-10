import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const Text("Beycombat Logger", style: TextStyle(fontSize: 25)),
        Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Theme.of(context).splashColor,
            onTap: () {
              debugPrint('Card tapped.');
            },
            child: SizedBox(
              width: 300,
              height: 120,
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('All Time Max',
                            style: TextStyle(fontSize: 18)),
                        Text('Launch Power',
                            style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).colorScheme.outline)),
                        const Spacer(),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Text('1000LP',
                                style: TextStyle(
                                    fontSize: 20,
                                    color:
                                        Theme.of(context).colorScheme.primary)))
                      ])),
            ),
          ),
        ),
        const Spacer()
      ],
    ));
  }
}
