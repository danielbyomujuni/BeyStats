import 'package:bey_stats/widgets/format_date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('displays correct date format with "st" suffix', (WidgetTester tester) async {
    final DateTime date = DateTime(2023, 8, 1); // 1st August 2023

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormatDateTime(launchDate: date),
        ),
      ),
    );

    expect(find.text('Tue 1st\nAugust, 2023'), findsOneWidget);
  });

  testWidgets('displays correct date format with "nd" suffix', (WidgetTester tester) async {
    final DateTime date = DateTime(2023, 8, 2); // 2nd August 2023

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormatDateTime(launchDate: date),
        ),
      ),
    );

    expect(find.text('Wed 2nd\nAugust, 2023'), findsOneWidget);
  });

  testWidgets('displays correct date format with "rd" suffix', (WidgetTester tester) async {
    final DateTime date = DateTime(2023, 8, 3); // 3rd August 2023

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormatDateTime(launchDate: date),
        ),
      ),
    );

    expect(find.text('Thu 3rd\nAugust, 2023'), findsOneWidget);
  });

  testWidgets('displays correct date format with "th" suffix', (WidgetTester tester) async {
    final DateTime date = DateTime(2023, 8, 4); // 4th August 2023

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormatDateTime(launchDate: date),
        ),
      ),
    );

    expect(find.text('Fri 4th\nAugust, 2023'), findsOneWidget);
  });

  testWidgets('displays correct date format for 11th to 13th with "th" suffix', (WidgetTester tester) async {
    final List<DateTime> dates = [
      DateTime(2023, 8, 11), // 11th August 2023
      DateTime(2023, 8, 12), // 12th August 2023
      DateTime(2023, 8, 13), // 13th August 2023
    ];

    for (var date in dates) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormatDateTime(launchDate: date),
          ),
        ),
      );

      expect(find.textContaining('th\nAugust, 2023'), findsOneWidget);
    }
  });

  testWidgets('displays correct date format for other months', (WidgetTester tester) async {
    final DateTime date = DateTime(2023, 12, 25); // 25th December 2023

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormatDateTime(launchDate: date),
        ),
      ),
    );

    expect(find.text('Mon 25th\nDecember, 2023'), findsOneWidget);
  });
}
