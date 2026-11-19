// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:capstone_ramirez/main.dart';
import 'package:capstone_ramirez/screens/login_page.dart';
import 'package:capstone_ramirez/widgets/clinic_auth_widgets.dart';

void main() {
  testWidgets('login page uses a 30% background image', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Opacity &&
            widget.opacity == 0.3 &&
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
    expect(find.text('UP FOR A\nCHECK UP?'), findsOneWidget);
    expect(
      tester.widget<Text>(find.text('UP FOR A\nCHECK UP?')).style?.fontSize,
      36,
    );
    expect(find.text('Log in'), findsNWidgets(2));
    expect(find.byType(TextField), findsNWidgets(2));
  });

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
    expect(find.text('Student Form:'), findsOneWidget);
    expect(find.text('What do you feel right now?'), findsOneWidget);
    expect(find.text('Clinic check-in'), findsOneWidget);
    expect(find.text('Details (optional)'), findsOneWidget);
    expect(find.text('Recorded automatically when you join'), findsOneWidget);
    expect(find.text("You haven't joined the queue yet."), findsOneWidget);
    expect(find.text('Status:'), findsNothing);
    expect(find.text('--- in line'), findsNothing);

    final joinButton = find.text('Join Queue');
    final joinButtonWidget = find.widgetWithText(ElevatedButton, 'Join Queue');
    expect(tester.getSize(joinButtonWidget), const Size(200, 48));
    expect(tester.widget<TextField>(find.byType(TextField)).maxLines, 3);
    await tester.ensureVisible(joinButton);
    await tester.tap(joinButton);
    await tester.pumpAndSettle();
    expect(find.text('Please select a symptom.'), findsOneWidget);
    expect(find.text("You haven't joined the queue yet."), findsOneWidget);
    expect(find.text('Status:'), findsNothing);

    final symptomDropdown = find.byType(DropdownButtonFormField<String>);
    final symptomDropdownWidget = tester
        .widget<DropdownButtonFormField<String>>(symptomDropdown);
    expect(symptomDropdownWidget.decoration.fillColor, const Color(0xFFFFF8EC));
    expect(symptomDropdownWidget.decoration.contentPadding?.vertical, 32);
    await tester.ensureVisible(symptomDropdown);
    await tester.tap(symptomDropdown);
    await tester.pumpAndSettle();
    expect(find.text('Fever'), findsOneWidget);
    expect(find.text('Other'), findsOneWidget);
    await tester.tap(find.text('Other').last);
    await tester.pumpAndSettle();
    expect(find.text('Other symptom'), findsOneWidget);

    final otherSymptomField = find.byType(TextFormField).first;
    await tester.ensureVisible(otherSymptomField);
    await tester.enterText(otherSymptomField, 'Rash');
    await tester.ensureVisible(joinButton);
    await tester.tap(joinButton);
    await tester.pumpAndSettle();

    expect(find.text('#4 in line'), findsOneWidget);
    expect(find.text('Waiting...'), findsOneWidget);
    expect(find.text('Status:'), findsOneWidget);
    expect(find.text('Checked in'), findsNothing);
    expect(find.text('Joined Queue'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            RegExp(
              r'^\d{1,2}/\d{1,2}/\d{4} \d{2}:\d{2} (AM|PM)$',
            ).hasMatch(widget.data ?? ''),
      ),
      findsOneWidget,
    );
  });
}
