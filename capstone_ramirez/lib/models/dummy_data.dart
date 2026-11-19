class DummyQueueEntry {
  const DummyQueueEntry({
    required this.queuePosition,
    required this.symptom,
    required this.status,
  });

  final int queuePosition;
  final String symptom;
  final String status;
}

const dummySymptoms = [
  'Headache',
  'Fever',
  'Cough',
  'Cold or flu symptoms',
  'Sore throat',
  'Stomach pain',
  'Nausea',
  'Dizziness',
  'Injury',
  'Other',
];

const dummyQueueEntries = [
  DummyQueueEntry(
    queuePosition: 1,
    symptom: 'Headache',
    status: 'Waiting',
  ),
  DummyQueueEntry(
    queuePosition: 2,
    symptom: 'Fever',
    status: 'Waiting',
  ),
  DummyQueueEntry(
    queuePosition: 3,
    symptom: 'Stomach pain',
    status: 'Waiting',
  ),
];
