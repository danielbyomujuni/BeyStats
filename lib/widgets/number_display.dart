import 'package:flutter/material.dart';

class NumberDisplay extends StatelessWidget {
  final int number;
  final TextStyle style;

  NumberDisplay({required this.number, required this.style, Key? key})
      : super(key: key);

  String _formatNumber(int number) {
    // Convert the number to a string and pad it with spaces to ensure it's 5 characters long
    return number.toString().padRight(6);
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(
          width: 70.0,
          child: Text(
            _formatNumber(number),
            style: style,
          )),
      Text(
        " LP",
        style: style,
      )
    ]);
  }
}

// Usage exampl