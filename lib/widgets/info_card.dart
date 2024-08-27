import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String unit;
  final int value;
  final VoidCallback? onTap;

  const InfoCard(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.value,
      required this.unit,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      color: Theme.of(context).colorScheme.secondary,
      child: InkWell(
        splashColor: Theme.of(context).splashColor,
        onTap: () {
          debugPrint('Card tapped.');
          if (onTap != null) {
            onTap!();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  overflow: TextOverflow.fade,
                  title,
                  style: const TextStyle(fontSize: 16),
                )),
            FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                )),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('$value',
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.primary)),
                    Text(unit,
                        style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.primary)),
                  ]),
            ),
          ]),
        ),
      ),
    );
  }
}
