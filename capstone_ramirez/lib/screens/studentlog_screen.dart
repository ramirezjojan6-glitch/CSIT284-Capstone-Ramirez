import 'package:flutter/material.dart';

import '../widgets/clinic_auth_widgets.dart';
import '../widgets/student_log_header.dart';
import '../widgets/student_queue_form.dart';

class StudentLogScreen extends StatelessWidget {
  const StudentLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                StudentLogHeader(topInset: topInset),
                const Expanded(
                  child: StudentQueueForm(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
