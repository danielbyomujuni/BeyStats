import 'package:flutter/material.dart';

class BlankView extends StatelessWidget {
  const BlankView({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Nothing Here (Yet)',
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontSize: 18,
        ),
      ),
    );
  }
}
