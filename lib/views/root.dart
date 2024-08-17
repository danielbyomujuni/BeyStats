import 'package:bey_stats/views/blank_view.dart';
import 'package:bey_stats/views/profile_view.dart';
import 'package:bey_stats/views/stats_view.dart';
import 'package:bey_stats/widgets/launch_power_chart.dart';
import 'package:flutter/material.dart';
import 'package:bey_stats/views/battlepass/battlepass_modal.dart';
import 'home_view.dart';
import 'navigation_bar.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  int pageIndex = 0;
  List<Widget> pages = [
    const HomeView(),
    const StatsView(),
    //const LaunchPowerChart(),
    //ProfileView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beycombat Logger'),
      ),
      body: getBody(),
      bottomNavigationBar: getFooter(context, pageIndex, selectedTab),
      floatingActionButton: BattlepassModal(),
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
