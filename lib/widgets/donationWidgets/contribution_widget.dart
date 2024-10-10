import 'package:bey_stats/app_states/experiment_state.dart';
import 'package:bey_stats/services/database/donation_database.dart';
import 'package:bey_stats/services/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContributionWidget extends StatefulWidget {
  const ContributionWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContributionWidgetState createState() => _ContributionWidgetState();
}

class _ContributionWidgetState extends State<ContributionWidget> {
  late double _totalContribution = 0.0;

  @override
  void initState() {
    super.initState();
    _getTotalContribution().then((value) {
      Logger.debug('INIT: $value');
      setState(() {
        _totalContribution = value;
      });
    });
  }

  Future<double> _getTotalContribution() async {
    DonationDatabase db = await DonationDatabase.getInstance();
    double value = await db.getTotalDonatedAmount();
    db.addListener(updateValue);
    return value;
  }

  void updateValue(double value) {
    Logger.debug('REFRESH: $value');
    setState(() {
      _totalContribution = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExperimentState, Map<String, bool>>(
        builder: (context, state) {
      if (ExperimentState.isTotalDonationExperimentOn(context)) {
        return Column(
          children: [
            Text(AppLocalizations.of(context)!.yourTotalContribution),
            Text(MoneyFormatter(amount: _totalContribution)
                .output
                .compactSymbolOnLeft),
          ],
        );
      } 
      return const SizedBox.shrink();
    });
  }
}
