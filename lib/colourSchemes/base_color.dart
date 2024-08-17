import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:flutter/material.dart';

class BaseColor extends ColorScheme {
  BaseColor()
      : super(
            surface: catppuccin.mocha.crust,
            brightness: Brightness.dark,
            error: catppuccin.mocha.red,
            onError: catppuccin.mocha.rosewater,
            onPrimary: catppuccin.mocha.subtext0,
            onSecondary: const Color.fromARGB(255, 255, 255, 0),
            onSurface: catppuccin.mocha.text,
            primary: const Color(0xff4d8d50),
            secondary: catppuccin.mocha.base,
            inverseSurface: const Color.fromARGB(255, 128, 128, 128),
            surfaceContainer: catppuccin.mocha.base);
}
