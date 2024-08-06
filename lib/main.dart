import 'package:bey_combat_logger/views/root.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff40C4FF),
        brightness: Brightness.light,
      ),
    ),
    darkTheme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff40C4FF),
        brightness: Brightness.dark,
      ),
    ),
    themeMode: ThemeMode.system,
    debugShowCheckedModeBanner: false,
    home: Root(),
  ));
}
