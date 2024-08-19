import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bey_stats/widgets/launch_list.dart'; // Adjust this import to match your file structure
import 'package:bey_stats/structs/launch_data.dart';
import 'package:bey_stats/widgets/format_date_time.dart';
import 'package:bey_stats/widgets/number_display.dart';

void main() {
  testWidgets('displays "No Launches" when the list is empty', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LaunchList(launches: []),
        ),
      ),
    );

    expect(find.text('No Launches'), findsOneWidget);
  });

  testWidgets('displays a list of launches', (WidgetTester tester) async {
    final launches = [
      LaunchData(1, 350, DateTime(2023, 8, 10)),
      LaunchData(2, 420, DateTime(2023, 8, 11)),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LaunchList(launches: launches),
        ),
      ),
    );

    expect(find.byType(Card), findsNWidgets(2));
    expect(find.byType(ListTile), findsNWidgets(2));
    expect(find.byType(NumberDisplay), findsNWidgets(2));
    expect(find.byType(FormatDateTime), findsNWidgets(2));

    expect(find.text('Session 1'), findsOneWidget);
    expect(find.text('Session 2'), findsOneWidget);

    expect(find.textContaining('350'), findsOneWidget);
    expect(find.textContaining('420'), findsOneWidget);
  });

  testWidgets('LaunchList correctly handles multiple launches', (WidgetTester tester) async {
    final launches = List.generate(
      5,
      (index) => LaunchData(
        index + 1,
        300 + index * 10,
        DateTime(2023, 8, 10).add(Duration(days: index)),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LaunchList(launches: launches),
        ),
      ),
    );

    expect(find.byType(Card), findsNWidgets(5));
    expect(find.byType(ListTile), findsNWidgets(5));
  });
}
