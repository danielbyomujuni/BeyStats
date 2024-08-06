import 'package:bey_combat_logger/views/battlepass/onboarding_turnon.dart';
import 'package:flutter/material.dart';

class BattlepassOnboarding extends StatefulWidget {
  VoidCallback _closeModal;

  BattlepassOnboarding(this._closeModal, {super.key});

  @override
  _BattlepassOnboardingState createState() => _BattlepassOnboardingState();
}

class _BattlepassOnboardingState extends State<BattlepassOnboarding> {
  int pageIndex = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    pages.add(OnboardingTurnon(() {}, widget._closeModal));
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        itemCount: pages.length,
        itemBuilder: (_, i) {
          return pages[i];
        });
  }
}
