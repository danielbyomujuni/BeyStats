import 'package:bey_stats/app_states/experiment_state.dart';
import 'package:bey_stats/services/logger.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Footer extends StatefulWidget {
  final int pageIndex;
  final Function(int) selectedTab;

  const Footer({super.key, required this.pageIndex, required this.selectedTab});

  @override
  // ignore: library_private_types_in_public_api
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  List<IconData> iconItems = [Icons.home, Icons.analytics];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExperimentState, Map<String, bool>>(
      builder: (context, state) {
        iconItems = [Icons.home, Icons.analytics];
        if (state[ExperimentState.getCollectionID()] ?? false) {
          iconItems.add(Icons.folder_open);
        }
        while ((iconItems.length % 2) != 0) {
          iconItems.add(Icons.lock);
        }
        Logger.debug("Updated Navbar to length of: ${iconItems.length}");

        return AnimatedBottomNavigationBar(
          activeColor: Theme.of(context).colorScheme.primary,
          splashColor: Theme.of(context).splashColor,
          inactiveColor:
              Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          icons: iconItems,
          activeIndex: widget.pageIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          leftCornerRadius: 10,
          iconSize: 25,
          rightCornerRadius: 10,
          onTap: widget.selectedTab,
        );
      },
    );
  }
}
