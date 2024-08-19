import 'package:bey_stats/colourSchemes/base_color.dart';
import 'package:bey_stats/views/root.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      fontFamily: 'Orbitron',
      colorScheme: BaseColor(),
    ),
    darkTheme: ThemeData(
      useMaterial3: true,
      fontFamily: 'Orbitron',
      colorScheme: BaseColor(),
    ),
    themeMode: ThemeMode.dark,
    debugShowCheckedModeBanner: false,
    home: const Root(),
  ));
}
