import 'package:bey_stats/colourSchemes/base_color.dart';
import 'package:bey_stats/views/blank_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubRoot extends StatefulWidget {
  final Widget? child;
  final String? subTitle;
  const SubRoot({super.key, this.child, this.subTitle});

  @override
  State<SubRoot> createState() => _SubRootState();
}

class _SubRootState extends State<SubRoot> {
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
        home: Scaffold(
          appBar: AppBar(
            elevation: 1.0,
            title: FittedBox(
                child: Text(widget.subTitle == null
                    ? AppLocalizations.of(context)!.bey_stats
                    : "${AppLocalizations.of(context)!.bey_stats} - ${widget.subTitle!}")),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Back',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: const <Widget>[
              //IconButton//IconButton
            ],
          ),
          body: widget.child ?? const BlankView(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ));
  }
}
