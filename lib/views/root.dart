import 'package:bey_stats/views/blank_view.dart';
import 'package:bey_stats/views/settings_view.dart';
import 'package:bey_stats/views/stats_view.dart';
import 'package:flutter/material.dart';
import 'package:bey_stats/views/battlepass/battlepass_modal.dart';
import 'home_view.dart';
import 'navigation_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  RootState createState() => RootState();
}

class RootState extends State<Root> {
  int pageIndex = 0;
  List<Widget> pages = [
    const HomeView(),
    const StatsView(),
    const BlankView(),
    const BlankView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text(AppLocalizations.of(context)!.bey_stats),
        actions: <Widget>[
          //IconButton
          IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Setting Icon',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SettingsView(),
              ));
            },
          ), //IconButton
        ],
      ),
      body: getBody(),
      bottomNavigationBar: getFooter(context, pageIndex, selectedTab),
      floatingActionButton: const BattlepassModal(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget getBody() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
        child: IndexedStack(
          index: pageIndex,
          children: pages,
        ));
  }

  void selectedTab(int index) {
    setState(() {
      pageIndex = index;
    });
  }
}
