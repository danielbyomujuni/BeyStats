import 'package:bey_stats/views/battlepass/onboarding/onboarding_pairing.dart';
import 'package:bey_stats/views/battlepass/onboarding/onboarding_remove_bey.dart';
import 'package:bey_stats/views/battlepass/onboarding/onboarding_scanning.dart';
import 'package:bey_stats/views/battlepass/onboarding/onboarding_turnon.dart';
import 'package:bey_stats/views/battlepass/onboarding/stats_onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BattlepassOnboarding extends StatefulWidget {
  final VoidCallback _closeModal;

  const BattlepassOnboarding(this._closeModal, {super.key});

  @override
  BattlepassOnboardingState createState() => BattlepassOnboardingState();
}

class BattlepassOnboardingState extends State<BattlepassOnboarding> {
  late PageController _pageController;

  int pageIndex = 0;
  List<Widget> pages = [];

  void nextModalPage() {
    pageIndex = 1;
    _pageController.nextPage(
        duration: const Duration(milliseconds: 100), curve: Curves.decelerate);
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);

    pages.add(OnboardingTurnon(nextModalPage, widget._closeModal));
    pages.add(OnboardingRemoveBey(nextModalPage, widget._closeModal));
    pages.add(OnboardingPairing(nextModalPage, widget._closeModal));
    pages.add(OnboardingScanning(nextModalPage, widget._closeModal));
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
