import 'package:flutter/material.dart';

import 'clinic_auth_widgets.dart';

class StudentLogHeader extends StatelessWidget {
  const StudentLogHeader({
    required this.topInset,
    required this.onLogout,
    super.key,
  });

  final double topInset;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: clinicMaroon,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
        border: const Border(
          bottom: BorderSide(color: clinicOrange, width: 1.5),
        ),
      ),
      padding: EdgeInsets.fromLTRB(16, topInset + 16, 20, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Image.asset(
                      'assets/cit logo.png',
                      width: 50,
                      height: 50,
                      semanticLabel: 'CIT logo',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'WILDCATS CLINIC',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              IconButton(
                key: const Key('student-logout-button'),
                tooltip: 'Log out',
                onPressed: onLogout,
                icon: const Icon(Icons.logout, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text(
              'Welcome, Student!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                height: 1.1,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
