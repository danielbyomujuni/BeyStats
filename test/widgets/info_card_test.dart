import 'package:bey_stats/widgets/info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('InfoCard displays title, subtitle, value, and unit correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: InfoCard(
            title: 'Test Title',
            subtitle: 'Test Subtitle',
            value: 42,
            unit: 'km',
          ),
        ),
      ),
    );

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Subtitle'), findsOneWidget);
    expect(find.text('42'), findsOneWidget);
    expect(find.text('km'), findsOneWidget);
  });

  testWidgets('InfoCard applies correct text styles', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: InfoCard(
            title: 'Test Title',
            subtitle: 'Test Subtitle',
            value: 42,
            unit: 'km',
          ),
        ),
      ),
    );

    final titleText = tester.widget<Text>(find.text('Test Title'));
    final subtitleText = tester.widget<Text>(find.text('Test Subtitle'));
    final valueText = tester.widget<Text>(find.text('42'));
    final unitText = tester.widget<Text>(find.text('km'));

    expect(titleText.style?.fontSize, 16);
    expect(subtitleText.style?.fontSize, 12);
    expect(valueText.style?.fontSize, 20);
    expect(unitText.style?.fontSize, 10);
  });
/*
  testWidgets('InfoCard reacts to tap', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GestureDetector(
            onTap: () {
              tapped = true;
            },
            child: const InfoCard(
              title: 'Test Title',
              subtitle: 'Test Subtitle',
              value: 42,
              unit: 'km',
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(InfoCard));
    expect(tapped, isTrue);
  });
  */
}
