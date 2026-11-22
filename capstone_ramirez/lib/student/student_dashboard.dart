import 'package:flutter/material.dart';

import '../authentication/auth_service.dart';
import '../login/login_screen.dart';
import '../models/user_model.dart';
import '../widgets/clinic_auth_widgets.dart';
import '../widgets/student_log_header.dart';
import '../widgets/student_queue_form.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final _authService = AuthService();
  bool _isCheckingAccess = true;
  String? _accessError;

  @override
  void initState() {
    super.initState();
    _checkAccess();
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingAccess) {
      return const Scaffold(
        backgroundColor: clinicMaroon,
        body: Center(child: CircularProgressIndicator(color: clinicOrange)),
      );
    }

    if (_accessError != null) {
      return Scaffold(
        backgroundColor: clinicMaroon,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Unable to verify your session.',
                style: TextStyle(color: Colors.white),
              ),
              TextButton(
                onPressed: _checkAccess,
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

    final topInset = MediaQuery.paddingOf(context).top;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const ClinicBackground(),
          SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StudentLogHeader(topInset: topInset, onLogout: _logout),
                const Expanded(child: StudentQueueForm()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkAccess() async {
    setState(() {
      _isCheckingAccess = true;
      _accessError = null;
    });

    try {
      final user = await _authService.getCurrentUser(
        requiredRole: UserRole.student,
      );
      if (!mounted) return;

      if (user == null) {
        Navigator.of(context).pushAndRemoveUntil<void>(
          MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
          (_) => false,
        );
        return;
      }

      setState(() => _isCheckingAccess = false);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isCheckingAccess = false;
        _accessError = 'Unable to verify your session.';
      });
    }
  }

  Future<void> _logout() async {
    try {
      await _authService.logout();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil<void>(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not log out. Please try again.')),
      );
    }
  }
}
