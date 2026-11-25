import 'package:flutter/material.dart';

import '../authentication/auth_service.dart';
import '../login/login_screen.dart';
import '../models/user_model.dart';
import '../repositories/visit_repository.dart';
import '../widgets/clinic_auth_widgets.dart';
import '../widgets/visit_queue_list.dart';

class NurseDashboard extends StatefulWidget {
  const NurseDashboard({required this.visitRepository, super.key});

  final VisitRepository visitRepository;

  @override
  State<NurseDashboard> createState() => _NurseDashboardState();
}

class _NurseDashboardState extends State<NurseDashboard> {
  final _authService = AuthService();
  bool _isCheckingAccess = true;
  String? _accessError;
  int _selectedIndex = 0;

  static const _titles = ['Visits', 'Queue', 'Profile / Logout'];

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

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const ClinicBackground(),
          SafeArea(
            child: Column(
              children: [
                _NurseHeader(title: _titles[_selectedIndex]),
                Expanded(child: _selectedPage()),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        indicatorColor: clinicOrange.withValues(alpha: 0.35),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.medical_services_outlined),
            selectedIcon: Icon(Icons.medical_services),
            label: 'Visits',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Queue',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile / Logout',
          ),
        ],
      ),
    );
  }

  Widget _selectedPage() {
    return switch (_selectedIndex) {
      0 => VisitQueueList(
        repository: widget.visitRepository,
        waitingOnly: false,
      ),
      1 => VisitQueueList(
        repository: widget.visitRepository,
        waitingOnly: true,
      ),
      _ => _profilePage(),
    };
  }

  Widget _profilePage() {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: clinicOrange, width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person, color: clinicMaroon, size: 44),
              const SizedBox(height: 8),
              const Text(
                'Nurse profile',
                style: TextStyle(
                  color: clinicMaroon,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                key: const Key('nurse-logout-button'),
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text('Log out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: clinicMaroon,
                  side: const BorderSide(color: clinicOrange, width: 1.5),
                ),
              ),
            ],
          ),
        ),
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
        requiredRole: UserRole.nurse,
      );
      if (!mounted) return;

      if (user == null) {
        Navigator.of(context).pushAndRemoveUntil<void>(
          MaterialPageRoute<void>(
            builder: (_) =>
                LoginScreen(visitRepository: widget.visitRepository),
          ),
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
        MaterialPageRoute<void>(
          builder: (_) => LoginScreen(visitRepository: widget.visitRepository),
        ),
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

class _NurseHeader extends StatelessWidget {
  const _NurseHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: clinicMaroon,
        border: Border(bottom: BorderSide(color: clinicOrange, width: 1.5)),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Row(
        children: [
          Image.asset(
            'assets/cit logo.png',
            width: 44,
            height: 44,
            semanticLabel: 'CIT logo',
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'WILDCATS CLINIC',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
