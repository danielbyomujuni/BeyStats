import 'package:bey_combat_logger/views/battlepass/battlepass_scanner.dart';
import 'package:bey_combat_logger/views/battlepass/onboarding/onboarding_pairing.dart';
import 'package:bey_combat_logger/views/battlepass/onboarding/onboarding_remove_bey.dart';
import 'package:bey_combat_logger/views/battlepass/onboarding/onboarding_scanning.dart';
import 'package:bey_combat_logger/views/battlepass/onboarding/onboarding_turnon.dart';
import 'package:bey_combat_logger/views/battlepass/onboarding/stats_onboarding.dart';
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

  void next_page() {
    pageIndex = 1;
    _pageController.nextPage(
        duration: Duration(milliseconds: 100), curve: Curves.decelerate);
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);

    pages.add(OnboardingTurnon(next_page, widget._closeModal));
    pages.add(OnboardingRemoveBey(next_page, widget._closeModal));
    pages.add(OnboardingPairing(next_page, widget._closeModal));
    pages.add(OnboardingScanning(next_page, widget._closeModal));
    pages.add(StatsOnboarding(() {}, widget._closeModal));

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
