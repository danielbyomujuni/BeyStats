import 'package:bey_stats/structs/battlepass_debug.dart';
import 'package:bey_stats/views/battlepass/onboarding/error_onboarding.dart';
import 'package:bey_stats/views/battlepass/onboarding/onboarding_pairing.dart';
import 'package:bey_stats/views/battlepass/onboarding/onboarding_remove_bey.dart';
import 'package:bey_stats/views/battlepass/onboarding/onboarding_turnon.dart';
import 'package:bey_stats/views/blank_view.dart';
import 'package:bey_stats/views/settings/battlepass_bug_scanning.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BattlepassBugModal extends StatefulWidget {
  final Function(BattlepassDebug) _debugFunction;
  final VoidCallback _closeModal;

  const BattlepassBugModal(this._closeModal, this._debugFunction, {super.key});

  @override
  BattlepassBugModalState createState() => BattlepassBugModalState();
}

class BattlepassBugModalState extends State<BattlepassBugModal> {
  late PageController _pageController;

  int pageIndex = 0;
  List<Widget> pages = [];

  void nextModalPage() {
    pageIndex = 1;
    _pageController.nextPage(
        duration: const Duration(milliseconds: 100), curve: Curves.decelerate);
  }

  void errorModalPage() {
    pageIndex = 5;
    _pageController.animateToPage(4,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);

    pages.add(OnboardingTurnon(nextModalPage, widget._closeModal));
    pages.add(OnboardingRemoveBey(nextModalPage, widget._closeModal));
    pages.add(OnboardingPairing(nextModalPage, widget._closeModal));
    pages.add(BattlepassBugScanning(
        widget._debugFunction, widget._closeModal, errorModalPage));
    pages.add(ErrorOnboarding(widget._closeModal));

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 900,
      padding: const EdgeInsets.fromLTRB(20, 13, 20, 28),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
                child: PageView.builder(
                    controller: _pageController,
                    itemCount: pages.length,
                    onPageChanged: (value) => {
                          setState(() {
                            pageIndex = value;
                          })
                        },
                    itemBuilder: (_, i) {
                      return pages[i];
                    }))
          ],
        ),
      ),
    );
  }
}
