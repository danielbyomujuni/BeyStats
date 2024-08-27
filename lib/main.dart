import 'package:bey_stats/colourSchemes/base_color.dart';
import 'package:bey_stats/views/root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
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
