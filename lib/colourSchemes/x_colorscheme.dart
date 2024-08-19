import 'package:flutter/material.dart';

class XColorscheme extends ColorScheme {
  const XColorscheme()
      : super(
            surface: const Color.fromARGB(255, 93, 93, 93),
            brightness: Brightness.light,
            error: const Color.fromARGB(255, 115, 115, 115),
            onError: const Color.fromARGB(255, 255, 0, 0),
            onPrimary: const Color.fromARGB(255, 0, 0, 0),
            onSecondary: const Color.fromARGB(255, 0, 0, 0),
            onSurface: const Color.fromARGB(255, 0, 0, 0),
            primary: const Color.fromARGB(255, 134, 255, 104),
            secondary: const Color.fromARGB(255, 0, 238, 255),
            inverseSurface: const Color.fromARGB(255, 69, 161, 46));
}
