import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/visit_model.dart';
import '../repositories/visit_repository.dart';
import 'clinic_auth_widgets.dart';

class VisitQueueList extends StatefulWidget {
  const VisitQueueList({
    required this.repository,
    required this.waitingOnly,
    super.key,
  });

  final VisitRepository repository;
  final bool waitingOnly;

  @override
  State<VisitQueueList> createState() => _VisitQueueListState();
}

class _VisitQueueListState extends State<VisitQueueList> {
  late Stream<List<VisitModel>> _visits;
  final Set<String> _busyVisitIds = {};

  @override
  void initState() {
    super.initState();
    _visits = widget.repository.watchAll();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<VisitModel>>(
      stream: _visits,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Unable to load clinic visits.'),
                TextButton(
                  onPressed: _retry,
                  child: const Text('Try again'),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: clinicMaroon),
          );
        }

        final visits = snapshot.data!
            .where(
              (visit) =>
                  !widget.waitingOnly || visit.status == VisitStatus.waiting,
            )
            .toList(growable: false);
        if (visits.isEmpty) {
          return Center(
            child: Text(
              widget.waitingOnly ? 'The queue is empty' : 'No visits yet',
              style: const TextStyle(
                color: clinicMaroon,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: visits.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) => _buildVisitCard(visits[index]),
        );
      },
    );
  }

  Widget _buildVisitCard(VisitModel visit) {
    final isBusy = _busyVisitIds.contains(visit.id);
    final nextStatus = visit.status == VisitStatus.waiting
        ? VisitStatus.attended
        : VisitStatus.waiting;

    return Card(
      key: Key('visit-${visit.id}'),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: clinicOrange, width: 1.2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    visit.studentName,
                    style: const TextStyle(
                      color: clinicMaroon,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  visit.status.label,
                  style: const TextStyle(
                    color: clinicMaroon,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text('Student ID: ${visit.studentId}'),
            Text('Symptom: ${visit.symptom}'),
            if (visit.details.isNotEmpty) Text('Details: ${visit.details}'),
            Text('Checked in: ${_formatTimestamp(visit.createdAt)}'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton.icon(
                  key: Key('visit-status-${visit.id}'),
                  onPressed: isBusy
                      ? null
                      : () => _updateStatus(visit, nextStatus),
                  icon: Icon(
                    visit.status == VisitStatus.waiting
                        ? Icons.check_circle_outline
                        : Icons.replay,
                  ),
                  label: Text(
                    visit.status == VisitStatus.waiting
                        ? 'Mark attended'
                        : 'Return to queue',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: clinicMaroon,
                    side: const BorderSide(color: clinicOrange),
                  ),
                ),
                TextButton.icon(
                  key: Key('visit-delete-${visit.id}'),
                  onPressed: isBusy ? null : () => _confirmDelete(visit),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateStatus(VisitModel visit, VisitStatus status) async {
    setState(() => _busyVisitIds.add(visit.id));
    try {
      await widget.repository.update(visit.copyWith(status: status));
    } on FirebaseException catch (error) {
      if (!mounted) return;
      _showError(error, 'Could not update visit');
    } finally {
      if (mounted) {
        setState(() => _busyVisitIds.remove(visit.id));
      }
    }
  }

  Future<void> _confirmDelete(VisitModel visit) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete visit?'),
        content: Text('Delete ${visit.studentName}\'s clinic visit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (shouldDelete != true || !mounted) {
      return;
    }

    setState(() => _busyVisitIds.add(visit.id));
    try {
      await widget.repository.delete(visit.id);
    } on FirebaseException catch (error) {
      if (!mounted) return;
      _showError(error, 'Could not delete visit');
    } finally {
      if (mounted) {
        setState(() => _busyVisitIds.remove(visit.id));
      }
    }
  }

  void _showError(FirebaseException error, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action: ${error.message ?? error.code}')),
    );
  }

  void _retry() {
    setState(() {
      _visits = widget.repository.watchAll();
    });
  }

  String _formatTimestamp(DateTime timestamp) {
    final localTime = timestamp.toLocal();
    final hour = localTime.hour % 12 == 0 ? 12 : localTime.hour % 12;
    final period = localTime.hour >= 12 ? 'PM' : 'AM';
    return '${localTime.month}/${localTime.day}/${localTime.year} '
        '${_twoDigits(hour)}:${_twoDigits(localTime.minute)} $period';
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');
}
