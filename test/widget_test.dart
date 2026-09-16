import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quizapp/main.dart';

void main() {
  testWidgets('reveals answers and navigates between cards', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FlashcardApp());

    expect(find.text('What is the capital of Japan?'), findsOneWidget);
    expect(find.text('Tokyo'), findsNothing);

    await tester.tap(find.text('Show answer'));
    await tester.pump();
    expect(find.text('Tokyo'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pump();
    expect(find.text('What does HTTP stand for?'), findsOneWidget);
    expect(find.text('Tokyo'), findsNothing);
  });

  testWidgets('adds a custom card', (WidgetTester tester) async {
    await tester.pumpWidget(const FlashcardApp());

    await tester.tap(find.byTooltip('Add card'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Question'),
      'What is 2 + 2?',
    );
    await tester.enterText(find.widgetWithText(TextFormField, 'Answer'), '4');
    await tester.tap(find.text('Add card'));
    await tester.pumpAndSettle();

    expect(find.text('What is 2 + 2?'), findsOneWidget);
    expect(find.text('4'), findsNothing);
  });
}
