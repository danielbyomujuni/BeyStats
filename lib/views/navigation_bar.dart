import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

Widget getFooter(
    BuildContext context, int pageIndex, Function(int) selectedTab) {
  List<IconData> iconItems = [
    Icons.home,
    Icons.analytics,
    //Icons.show_chart,
    //Icons.person,
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
    onTap: selectedTab,
  );
}
