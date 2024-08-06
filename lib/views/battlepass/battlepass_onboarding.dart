import 'package:bey_combat_logger/views/battlepass/onboarding_remove_bey.dart';
import 'package:bey_combat_logger/views/battlepass/onboarding_turnon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BattlepassOnboarding extends StatefulWidget {
  VoidCallback _closeModal;

  BattlepassOnboarding(this._closeModal, {super.key});

  @override
  _BattlepassOnboardingState createState() => _BattlepassOnboardingState();
}

class _BattlepassOnboardingState extends State<BattlepassOnboarding> {
  late PageController _pageController;

  int pageIndex = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);

    pages.add(OnboardingTurnon(() {
      pageIndex = 1;

      _pageController.nextPage(
          duration: Duration(milliseconds: 100), curve: Curves.decelerate);
    }, widget._closeModal));
    pages.add(OnboardingRemoveBey(() {}, widget._closeModal));
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: _pageController,
        itemCount: pages.length,
        onPageChanged: (value) => {
              setState(() {
                pageIndex = value;
              })
            },
        itemBuilder: (_, i) {
          return pages[i];
        });
  }
}
