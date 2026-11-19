import 'package:flutter/material.dart';

import '../models/dummy_data.dart';
import 'clinic_auth_widgets.dart';

class StudentQueueForm extends StatefulWidget {
  const StudentQueueForm({super.key});

  @override
  State<StudentQueueForm> createState() => _StudentQueueFormState();
}

class _StudentQueueFormState extends State<StudentQueueForm> {
  static int _nextQueuePosition = dummyQueueEntries.length + 1;

  final _formKey = GlobalKey<FormState>();
  final _otherSymptomController = TextEditingController();
  final _detailsController = TextEditingController();

  String? _selectedSymptom;
  DateTime? _checkInTime;
  int? _queuePosition;

  bool get _hasJoined => _queuePosition != null;

  @override
  void dispose() {
    _otherSymptomController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(8, 24, 8, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 0, 0, 8),
            child: Text(
              'Student Form:',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: clinicOrange, width: 1.2),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 18),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: Text(
                      'What do you feel right now?',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F0EF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          color: clinicMaroon,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Clinic check-in',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                _checkInTime == null
                                    ? 'Recorded automatically when you join'
                                    : _formatTimestamp(_checkInTime!),
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Symptom:',
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedSymptom,
                    isExpanded: true,
                    decoration: _fieldDecoration(
                      hintText: 'Choose a symptom',
                      prominent: true,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: clinicMaroon,
                      size: 28,
                    ),
                    items: dummySymptoms
                        .map(
                          (symptom) => DropdownMenuItem(
                            value: symptom,
                            child: Text(symptom),
                          ),
                        )
                        .toList(),
                    onChanged: _hasJoined
                        ? null
                        : (symptom) {
                            setState(() {
                              _selectedSymptom = symptom;
                            });
                          },
                    validator: (symptom) =>
                        symptom == null ? 'Please select a symptom.' : null,
                  ),
                  if (_selectedSymptom == 'Other') ...[
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _otherSymptomController,
                      enabled: !_hasJoined,
                      decoration: _fieldDecoration(
                        labelText: 'Other symptom',
                        hintText: 'Enter your symptom',
                      ),
                      validator: (value) {
                        if (_selectedSymptom == 'Other' &&
                            (value == null || value.trim().isEmpty)) {
                          return 'Please describe your symptom.';
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 14),
                  const Text(
                    'Details (optional)',
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _detailsController,
                    enabled: !_hasJoined,
                    minLines: 3,
                    maxLines: 3,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: _fieldDecoration(
                      hintText: 'Add any helpful details',
                    ),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: _hasJoined ? null : _joinQueue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: clinicMaroon,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: clinicMaroon.withValues(
                            alpha: 0.7,
                          ),
                          disabledForegroundColor: Colors.white,
                          side: const BorderSide(
                            color: clinicOrange,
                            width: 1.5,
                          ),
                          shape: const StadiumBorder(),
                          minimumSize: const Size(0, 48),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: Text(_hasJoined ? 'Joined Queue' : 'Join Queue'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (_hasJoined)
                    _buildStatusCard()
                  else
                    const Center(
                      child: Text(
                        "You haven't joined the queue yet.",
                        style: TextStyle(
                          color: clinicMaroon,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration({
    String? labelText,
    String? hintText,
    bool prominent = false,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(prominent ? 22 : 18),
      borderSide: BorderSide(color: clinicOrange, width: prominent ? 2.2 : 1.2),
    );

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      filled: true,
      fillColor: prominent ? const Color(0xFFFFF8EC) : Colors.white,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 18,
        vertical: prominent ? 16 : 12,
      ),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: clinicOrange, width: 2),
      ),
      errorBorder: border.copyWith(
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: BoxDecoration(
        color: clinicMaroon,
        border: Border.all(color: clinicOrange, width: 1.5),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  _queuePosition == null
                      ? '--- in line'
                      : '#$_queuePosition in line',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                'Waiting...',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _joinQueue() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _queuePosition = _nextQueuePosition++;
      _checkInTime = DateTime.now();
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
