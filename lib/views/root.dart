import 'package:bey_combat_logger/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:bey_combat_logger/views/battlepass/battlepass_modal.dart';
import 'home_view.dart';
import 'navigation_bar.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  int pageIndex = 0;
  List<Widget> pages = [HomeView(), HomeView(), HomeView(), ProfileView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      bottomNavigationBar: getFooter(context, pageIndex, selectedTab),
      floatingActionButton: BattlepassModal(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  void selectedTab(int index) {
    setState(() {
      pageIndex = index;
    });
  }
}
