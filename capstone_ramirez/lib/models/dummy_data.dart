import 'user_model.dart';

class DummyUserRecord {
  const DummyUserRecord({
    required this.id,
    required this.name,
    required this.password,
    required this.role,
  });

  final String id;
  final String name;
  final String password;
  final UserRole role;

  UserModel toUserModel() => UserModel(id: id, name: name, role: role);
}

// Plain-text passwords are for testing only.
const dummyUsers = <DummyUserRecord>[
  DummyUserRecord(
    id: 'S1001',
    name: 'Demo Student',
    password: 'student123',
    role: UserRole.student,
  ),
  DummyUserRecord(
    id: 'S1002',
    name: 'Demo Student Two',
    password: 'student456',
    role: UserRole.student,
  ),
  DummyUserRecord(
    id: 'N1001',
    name: 'Demo Nurse',
    password: 'nurse123',
    role: UserRole.nurse,
  ),
];

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
  DummyQueueEntry(queuePosition: 1, symptom: 'Headache', status: 'Waiting'),
  DummyQueueEntry(queuePosition: 2, symptom: 'Fever', status: 'Waiting'),
  DummyQueueEntry(queuePosition: 3, symptom: 'Stomach pain', status: 'Waiting'),
];
