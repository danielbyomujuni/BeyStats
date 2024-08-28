import 'package:bey_stats/colourSchemes/Ilinnuc_colorscheme.dart';
import 'package:bey_stats/colourSchemes/base_color.dart';
import 'package:bey_stats/views/root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late ColorScheme theme;

  @override
  void initState() {
    theme = BaseColor(); //const IlinnucColorscheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Orbitron',
        colorScheme: theme,
      ),
      debugShowCheckedModeBanner: false,
      home: const Root(),
    );
  }
}
