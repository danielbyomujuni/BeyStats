import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:bey_combat_logger/battlepass/beybattlepass_scanner.dart';
import 'package:bey_combat_logger/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
          useMaterial3: true,

          // Define the default brightness and colors.
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff40C4FF),
            brightness: Brightness.light,
          )),
      darkTheme: ThemeData(
          useMaterial3: true,

          // Define the default brightness and colors.
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff40C4FF),
            brightness: Brightness.dark,
          )), // standard dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: RootApp()));
}

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;
  List<Widget> pages = [
    HomeView(),
    HomeView(),
    HomeView(),
    HomeView(),
    HomeView(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: getBody(),
        bottomNavigationBar: getFooter(),
        floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () {
              selectedTab(4);
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(
              Icons.sync,
              size: 25,
            )
            //params
            ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      Icons.home,
      Icons.calendar_month,
      Icons.show_chart,
      Icons.person
    ];

    return AnimatedBottomNavigationBar(
      activeColor: Theme.of(context).colorScheme.primary,
      splashColor: Theme.of(context).splashColor,
      inactiveColor: Colors.black.withOpacity(0.5),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      icons: iconItems,
      activeIndex: pageIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 10,
      iconSize: 25,
      rightCornerRadius: 10,
      onTap: (index) {
        selectedTab(index);
      },
      //other params
    );
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
