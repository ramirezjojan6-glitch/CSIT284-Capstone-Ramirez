// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:capstone_ramirez/main.dart';

void main() {
  testWidgets('shows the clinic login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('FEELING UNWELL?\nGET IN LINE.'), findsOneWidget);
    expect(find.text('Log in'), findsNWidgets(2));
    expect(find.text('ID Number'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Continue with Facebook'), findsNothing);
    expect(find.text('New here? Sign up'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('login button opens the student log screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.widgetWithText(OutlinedButton, 'Log in'));
    await tester.pumpAndSettle();

    expect(find.text('Student Log Screen'), findsOneWidget);
  });
}
