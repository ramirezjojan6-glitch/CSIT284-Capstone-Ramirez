// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:capstone_ramirez/main.dart';
import 'package:capstone_ramirez/widgets/clinic_auth_widgets.dart';

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

    expect(find.text('WILD CLINIC'), findsOneWidget);
    expect(find.text('Welcome, Student!'), findsOneWidget);
    final header = find.ancestor(
      of: find.text('Welcome, Student!'),
      matching: find.byType(Container),
    );
    expect(
      tester.getSize(header).width,
      tester.getSize(find.byType(Scaffold)).width,
    );
    expect(tester.getTopLeft(header).dy, 0);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration ==
                const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
      ),
      findsOneWidget,
    );
    expect(
      tester.widget<Text>(find.text('Welcome, Student!')).style?.fontSize,
      28,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Opacity &&
            widget.opacity == 0.2 &&
            widget.child is Image &&
            (widget.child as Image).image ==
                const AssetImage('assets/clinic.webp'),
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is ColoredBox &&
            widget.color == clinicMaroon.withValues(alpha: 0.10),
      ),
      findsOneWidget,
    );
  });
}
