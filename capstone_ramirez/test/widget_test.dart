import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:capstone_ramirez/authentication/auth_service.dart';
import 'package:capstone_ramirez/login/login_screen.dart';
import 'package:capstone_ramirez/main.dart';
import 'package:capstone_ramirez/models/user_model.dart';
import 'package:capstone_ramirez/nurse/nurse_dashboard.dart';
import 'package:capstone_ramirez/student/student_dashboard.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('user role is serialized and restored from a map', () {
    final map = {'id': 'N1001', 'name': 'Demo Nurse', 'role': 'nurse'};

    expect(UserModel.fromMap(map).role, UserRole.nurse);
    expect(
      const UserModel(
        id: 'S1001',
        name: 'Demo Student',
        role: UserRole.student,
      ).toMap()['role'],
      'student',
    );
  });

  test('student two can log in and only its ID is persisted', () async {
    final user = await AuthService().login('S1002', 'student456');
    final preferences = await SharedPreferences.getInstance();

    expect(user.role, UserRole.student);
    expect(preferences.getString('clinic_user_id'), 'S1002');
    expect(preferences.getString('password'), isNull);
    expect(await AuthService().getCurrentUser(), user);
  });

  test('login rejects a role that does not match the account', () async {
    await expectLater(
      AuthService().login('N1001', 'nurse123', requiredRole: UserRole.student),
      throwsA(
        isA<AuthException>().having(
          (error) => error.message,
          'message',
          'The selected role does not match this account.',
        ),
      ),
    );
  });

  testWidgets('requires non-empty credentials', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    await tester.tap(find.byKey(const Key('login-submit-button')));
    await tester.pump();
    expect(
      find.text('Select whether you are a Student or Nurse.'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('student-role-option')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('login-submit-button')));
    await tester.pump();
    expect(find.text('Enter your ID number and password.'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('id-number-field')), 'S1001');
    await tester.tap(find.byKey(const Key('login-submit-button')));
    await tester.pump();
    expect(find.text('Enter your password.'), findsOneWidget);
  });

  testWidgets('wrong password and unknown ID use the same error', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    await _fillLogin(tester, id: 'S1001', password: 'wrong-password');

    expect(find.text('Incorrect ID number or password.'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('id-number-field')), 'UNKNOWN');
    await tester.tap(find.byKey(const Key('login-submit-button')));
    await tester.pumpAndSettle();
    expect(find.text('Incorrect ID number or password.'), findsOneWidget);
  });

  testWidgets('student login routes using the stored student role', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await _fillLogin(tester, id: 'S1001', password: 'student123');

    expect(find.byType(StudentDashboard), findsOneWidget);
    expect(find.text('Welcome, Student!'), findsOneWidget);
    expect(find.text('Student Form:'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(StudentDashboard), findsOneWidget);
  });

  testWidgets('nurse login opens the Visits, Queue, and Profile tabs', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await _fillLogin(tester, id: 'N1001', password: 'nurse123');

    expect(find.byType(NurseDashboard), findsOneWidget);
    expect(find.text('No visits yet'), findsOneWidget);
    await tester.tap(find.text('Queue'));
    await tester.pumpAndSettle();
    expect(find.text('The queue is empty'), findsOneWidget);

    await tester.tap(find.text('Profile / Logout'));
    await tester.pumpAndSettle();
    expect(find.text('Nurse profile'), findsOneWidget);
    expect(find.byKey(const Key('nurse-logout-button')), findsOneWidget);
  });

  testWidgets('restores a saved session by the stored account role', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'clinic_user_id': 'N1001'});

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(NurseDashboard), findsOneWidget);
    expect(find.text('Visits').first, findsOneWidget);
  });

  testWidgets('student dashboard rejects a nurse session', (tester) async {
    SharedPreferences.setMockInitialValues({'clinic_user_id': 'N1001'});

    await tester.pumpWidget(const MaterialApp(home: StudentDashboard()));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(StudentDashboard), findsNothing);
  });

  testWidgets('nurse dashboard rejects a student session', (tester) async {
    SharedPreferences.setMockInitialValues({'clinic_user_id': 'S1001'});

    await tester.pumpWidget(const MaterialApp(home: NurseDashboard()));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(NurseDashboard), findsNothing);
  });

  testWidgets('logout clears the session and leaves login as the root', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await _fillLogin(tester, id: 'S1001', password: 'student123');

    await tester.tap(find.byKey(const Key('student-logout-button')));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(await AuthService().restoreSession(), isNull);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}

Future<void> _fillLogin(
  WidgetTester tester, {
  required String id,
  required String password,
}) async {
  await tester.enterText(find.byKey(const Key('id-number-field')), id);
  await tester.enterText(find.byKey(const Key('password-field')), password);
  final roleKey = id.startsWith('N')
      ? const Key('nurse-role-option')
      : const Key('student-role-option');
  await tester.tap(find.byKey(roleKey));
  await tester.pump();
  await tester.tap(find.byKey(const Key('login-submit-button')));
  await tester.pumpAndSettle();
}
