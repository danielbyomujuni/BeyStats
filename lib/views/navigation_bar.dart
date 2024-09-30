import 'package:bey_stats/app_states/experiments.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget getFooter(
    BuildContext context, int pageIndex, Function(int) selectedTab) {
  return BlocBuilder<Experiments, Map<String, bool>>(
    builder: (context, count) {
      List<IconData> iconItems = [
        Icons.home,
        Icons.analytics,
      ];

      if (Experiments.isCollectionExperimentOn(context)) {
        iconItems.add(Icons.folder_open);
      }

      while ((iconItems.length % 2) != 0) {
        iconItems.add(Icons.lock);
      }

      return AnimatedBottomNavigationBar(
        activeColor: Theme.of(context).colorScheme.primary,
        splashColor: Theme.of(context).splashColor,
        inactiveColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
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
    },
  );
}
