import 'package:cloud_firestore/cloud_firestore.dart';

enum VisitStatus { waiting, attended }

extension VisitStatusLabel on VisitStatus {
  String get label => switch (this) {
    VisitStatus.waiting => 'Waiting',
    VisitStatus.attended => 'Attended',
  };
}

bool isSameLocalDate(DateTime first, DateTime second) {
  final firstLocal = first.toLocal();
  final secondLocal = second.toLocal();
  return firstLocal.year == secondLocal.year &&
      firstLocal.month == secondLocal.month &&
      firstLocal.day == secondLocal.day;
}

class VisitModel {
  const VisitModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.symptom,
    required this.details,
    required this.createdAt,
    required this.status,
  });

  final String id;
  final String studentId;
  final String studentName;
  final String symptom;
  final String details;
  final DateTime createdAt;
  final VisitStatus status;

  factory VisitModel.fromMap(Map<String, Object?> map) {
    final id = map['id'];
    final studentId = map['studentId'];
    final studentName = map['studentName'];
    final symptom = map['symptom'];
    final details = map['details'];
    final createdAtValue = map['createdAt'];
    final statusName = map['status'];

    if (id is! String ||
        studentId is! String ||
        studentName is! String ||
        symptom is! String ||
        details is! String ||
        statusName is! String) {
      throw const FormatException('Invalid visit record.');
    }

    final createdAt = switch (createdAtValue) {
      Timestamp timestamp => timestamp.toDate(),
      DateTime dateTime => dateTime,
      _ => throw const FormatException('Invalid visit timestamp.'),
    };
    final status = VisitStatus.values.firstWhere(
      (candidate) => candidate.name == statusName,
      orElse: () => throw FormatException('Unknown visit status: $statusName'),
    );

    return VisitModel(
      id: id,
      studentId: studentId,
      studentName: studentName,
      symptom: symptom,
      details: details,
      createdAt: createdAt,
      status: status,
    );
  }

  Map<String, Object?> toMap() => {
    'studentId': studentId,
    'studentName': studentName,
    'symptom': symptom,
    'details': details,
    'createdAt': Timestamp.fromDate(createdAt.toUtc()),
    'status': status.name,
  };

  VisitModel copyWith({
    String? symptom,
    String? details,
    VisitStatus? status,
  }) => VisitModel(
    id: id,
    studentId: studentId,
    studentName: studentName,
    symptom: symptom ?? this.symptom,
    details: details ?? this.details,
    createdAt: createdAt,
    status: status ?? this.status,
  );
}
