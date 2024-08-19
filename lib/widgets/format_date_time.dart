import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormatDateTime extends StatelessWidget {
  final DateTime launchDate;

  const FormatDateTime({super.key, required this.launchDate});

  String _formatDateTime(DateTime dateTime) {
    String daySuffix(int day) {
      if (day >= 11 && day <= 13) {
        return 'th';
      }
      switch (day % 10) {
        case 1:
          return 'st';
        case 2:
          return 'nd';
        case 3:
          return 'rd';
        default:
          return 'th';
      }
    }

    String formattedDate = DateFormat('EEE d\nMMMM, yyyy').format(dateTime);
    String dayWithSuffix = '${dateTime.day}${daySuffix(dateTime.day)}';

    return formattedDate.replaceFirst('${dateTime.day}', dayWithSuffix);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDateTime(launchDate),
      style: const TextStyle(fontSize: 14),
    );
  }
}