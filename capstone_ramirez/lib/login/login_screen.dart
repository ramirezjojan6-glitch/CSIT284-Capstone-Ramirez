import 'package:flutter/material.dart';

import '../authentication/auth_service.dart';
import '../models/user_model.dart';
import '../nurse/nurse_dashboard.dart';
import '../student/student_dashboard.dart';
import '../widgets/clinic_auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isSubmitting = false;
  String? _message;
  UserRole? _selectedRole;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          final panelHeight = screenHeight * 0.68;

          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: screenHeight * 0.57,
                child: const ClinicAuthBackground(
                  headline: 'FEELING WORSE?\nCHECK IT UP',
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: panelHeight,
                child: Container(
                  decoration: const BoxDecoration(
                    color: clinicMaroon,
                    border: Border.fromBorderSide(
                      BorderSide(color: clinicOrange, width: 1.5),
                    ),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(28, 20, 28, 16),
                      child: Center(
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 420),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Log in',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Choose your account type',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.95),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _RoleCard(
                                        key: const Key('student-role-option'),
                                        role: UserRole.student,
                                        icon: Icons.school_outlined,
                                        isSelected:
                                            _selectedRole == UserRole.student,
                                        enabled: !_isSubmitting,
                                        onTap: () => setState(() {
                                          _selectedRole = UserRole.student;
                                          _message = null;
                                        }),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _RoleCard(
                                        key: const Key('nurse-role-option'),
                                        role: UserRole.nurse,
                                        icon: Icons.medical_services_outlined,
                                        isSelected:
                                            _selectedRole == UserRole.nurse,
                                        enabled: !_isSubmitting,
                                        onTap: () => setState(() {
                                          _selectedRole = UserRole.nurse;
                                          _message = null;
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ClinicAuthInput(
                                  fieldKey: const Key('id-number-field'),
                                  controller: _idController,
                                  hintText: 'ID Number',
                                  keyboardType: TextInputType.text,
                                  enabled: !_isSubmitting,
                                ),
                                const SizedBox(height: 8),
                                ClinicAuthInput(
                                  fieldKey: const Key('password-field'),
                                  controller: _passwordController,
                                  hintText: 'Password',
                                  obscureText: !_isPasswordVisible,
                                  enabled: !_isSubmitting,
                                  suffixIcon: IconButton(
                                    key: const Key(
                                      'toggle-password-visibility',
                                    ),
                                    tooltip: _isPasswordVisible
                                        ? 'Hide password'
                                        : 'Show password',
                                    onPressed: _isSubmitting
                                        ? null
                                        : () => setState(
                                            () => _isPasswordVisible =
                                                !_isPasswordVisible,
                                          ),
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: clinicMaroon,
                                      size: 19,
                                    ),
                                  ),
                                ),
                                if (_message != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    _message!,
                                    key: const Key('login-error-message'),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 10),
                                ClinicAuthButton(
                                  key: const Key('login-submit-button'),
                                  label: _selectedRole == null
                                      ? 'Log in'
                                      : 'Log in as ${_selectedRole!.label}',
                                  isLoading: _isSubmitting,
                                  onPressed: _isSubmitting ? null : _submit,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final id = _idController.text.trim();
    final password = _passwordController.text;
    final message = _selectedRole == null
        ? 'Select whether you are a Student or Nurse.'
        : id.isEmpty && password.isEmpty
        ? 'Enter your ID number and password.'
        : id.isEmpty
        ? 'Enter your ID number.'
        : password.isEmpty
        ? 'Enter your password.'
        : null;

    if (message != null) {
      setState(() => _message = message);
      return;
    }

    setState(() {
      _isSubmitting = true;
      _message = null;
    });

    try {
      final user = await _authService.login(
        id,
        password,
        requiredRole: _selectedRole,
      );
      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil<void>(
        MaterialPageRoute<void>(
          builder: (_) => user.role == UserRole.student
              ? const StudentDashboard()
              : const NurseDashboard(),
        ),
        (_) => false,
      );
    } on AuthException catch (error) {
      if (!mounted) return;
      setState(() => _message = error.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _message = 'Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.role,
    required this.icon,
    required this.isSelected,
    required this.enabled,
    required this.onTap,
    super.key,
  });

  final UserRole role;
  final IconData icon;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: OutlinedButton(
        onPressed: enabled ? onTap : null,
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? clinicMaroon : Colors.white,
          foregroundColor: isSelected ? Colors.white : clinicMaroon,
          side: BorderSide(color: clinicOrange, width: isSelected ? 2.5 : 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(height: 3),
            Text(
              role.label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
