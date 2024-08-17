import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:flutter/material.dart';

class CatppuccinMocha extends ColorScheme {
  CatppuccinMocha()
      : super(
            surface: catppuccin.mocha.crust,
            brightness: Brightness.light,
            error: catppuccin.mocha.surface2,
            onError: catppuccin.mocha.red,
            onPrimary: catppuccin.mocha.green,
            onSecondary: catppuccin.mocha.blue,
            onSurface: catppuccin.mocha.text,
            primary: catppuccin.mocha.base,
            secondary: catppuccin.mocha.surface0,
            inverseSurface: catppuccin.mocha.surface1);
}
