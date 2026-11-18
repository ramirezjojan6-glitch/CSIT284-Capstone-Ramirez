// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:capstone_ramirez/main.dart';

void main() {
  testWidgets('shows the clinic login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('FEELING UNWELL?\nGET IN LINE.'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
    expect(find.text('Phone number / email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Continue with Facebook'), findsNothing);
    expect(find.text('New here? Sign up'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
