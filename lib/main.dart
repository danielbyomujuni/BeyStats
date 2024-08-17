import 'package:bey_stats/colourSchemes/base_color.dart';
import 'package:bey_stats/colourSchemes/catppuccin_mocha.dart';
import 'package:bey_stats/colourSchemes/x_colorscheme.dart';
import 'package:bey_stats/views/root.dart';
import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    home: Root(),
  ));
}
