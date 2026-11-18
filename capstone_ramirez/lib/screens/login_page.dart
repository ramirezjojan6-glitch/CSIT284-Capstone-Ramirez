import 'package:flutter/material.dart';

import '../widgets/clinic_auth_widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clinicMaroon,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          final panelHeight = screenHeight * 0.53;

          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: screenHeight * 0.57,
                child: const ClinicAuthBackground(
                  headline: 'FEELING UNWELL?\nGET IN LINE.',
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
                      padding: const EdgeInsets.fromLTRB(28, 24, 28, 16),
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
                                const ClinicAuthInput(
                                  hintText: 'Phone number / email',
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 8),
                                const ClinicAuthInput(
                                  hintText: 'Password',
                                  obscureText: true,
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'New here? Sign up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
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
}