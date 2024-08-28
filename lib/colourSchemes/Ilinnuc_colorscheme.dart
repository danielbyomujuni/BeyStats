import 'package:flutter/material.dart';

class IlinnucColorscheme extends ColorScheme {
  const IlinnucColorscheme()
      : super(
            surface: const Color(0xFF000000),
            brightness: Brightness.dark,
            error: const Color(0xFFbc0200),
            onError: const Color(0xFFE48d8d),
            onPrimary: const Color(0xFF4A5C5E),
            onSecondary: const Color(0xFF5C5E4A),
            onSurface: const Color(0xFFF7FFFD),
            primary: const Color(0xFFFF044B), //const Color(0xff4d8d50),
            secondary: const Color(0xFF232927),
            inverseSurface: const Color.fromARGB(255, 128, 128, 128),
            surfaceContainer: const Color(0xFF0c1011));
}
