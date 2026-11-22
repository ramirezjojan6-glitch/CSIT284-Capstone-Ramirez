import 'package:flutter/material.dart';

import 'authentication/auth_service.dart';
import 'login/login_screen.dart';
import 'models/user_model.dart';
import 'nurse/nurse_dashboard.dart';
import 'student/student_dashboard.dart';
import 'widgets/clinic_auth_widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SessionGate(),
    );
  }
}

class SessionGate extends StatefulWidget {
  const SessionGate({super.key});

  @override
  State<SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<SessionGate> {
  final _authService = AuthService();
  late Future<UserModel?> _restoreFuture;

  @override
  void initState() {
    super.initState();
    _restoreFuture = _authService.restoreSession();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: _restoreFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _StartupScreen();
        }

        if (snapshot.hasError) {
          return _StartupError(onRetry: _retry);
        }

        final user = snapshot.data;
        if (user == null) {
          return const LoginScreen();
        }

        return user.role == UserRole.student
            ? const StudentDashboard()
            : const NurseDashboard();
      },
    );
  }

  void _retry() {
    setState(() {
      _restoreFuture = _authService.restoreSession();
    });
  }
}

class _StartupScreen extends StatelessWidget {
  const _StartupScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: clinicMaroon,
      body: Center(child: CircularProgressIndicator(color: clinicOrange)),
    );
  }
}

class _StartupError extends StatelessWidget {
  const _StartupError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clinicMaroon,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Unable to restore your session.',
              style: TextStyle(color: Colors.white),
            ),
            TextButton(
              onPressed: onRetry,
              child: const Text(
                'Try again',
                style: TextStyle(color: clinicOrange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
