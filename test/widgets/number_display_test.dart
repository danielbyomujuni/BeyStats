import 'package:bey_stats/widgets/number_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('displays number with correct padding', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: NumberDisplay(
            number: 123,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );

    // Check that the number is displayed with padding
    expect(find.text('123   '), findsOneWidget);
  });

  testWidgets('displays "LP" after the number', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: NumberDisplay(
            number: 123,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );

    // Check that "LP" is displayed after the number
    expect(find.text(' LP'), findsOneWidget);
  });

  testWidgets('applies the correct style to both number and LP', (WidgetTester tester) async {
    const testStyle = TextStyle(fontSize: 18, color: Colors.red);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: NumberDisplay(
            number: 123,
            style: testStyle,
          ),
        ),
      ),
    );

    final numberText = tester.widget<Text>(find.text('123   '));
    final lpText = tester.widget<Text>(find.text(' LP'));

    expect(numberText.style?.fontSize, 18);
    expect(numberText.style?.color, Colors.red);
    expect(lpText.style?.fontSize, 18);
    expect(lpText.style?.color, Colors.red);
  });

  testWidgets('displays number correctly for a large value', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: NumberDisplay(
            number: 123456,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );

    // Check that the large number is displayed correctly without padding
    expect(find.text('123456'), findsOneWidget);
  });
}
