import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/visit_model.dart';

class VisitRepository {
  VisitRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  static const collectionName = 'visits';

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _visits =>
      _firestore.collection(collectionName);

  Future<VisitModel> create({
    required String studentId,
    required String studentName,
    required String symptom,
    required String details,
  }) async {
    final document = _visits.doc();
    final visit = VisitModel(
      id: document.id,
      studentId: studentId,
      studentName: studentName,
      symptom: symptom,
      details: details,
      createdAt: DateTime.now().toUtc(),
      status: VisitStatus.waiting,
    );
    await document.set(visit.toMap());
    return visit;
  }

  Future<VisitModel?> getById(String id) async {
    final document = await _visits.doc(id).get();
    if (!document.exists) {
      return null;
    }

    return _fromDocument(document);
  }

  Future<List<VisitModel>> getAll() async {
    final snapshot = await _visits.orderBy('createdAt').get();
    return snapshot.docs.map(_fromDocument).toList(growable: false);
  }

  Stream<List<VisitModel>> watchAll() =>
      _visits.orderBy('createdAt').snapshots().map(
        (snapshot) => snapshot.docs.map(_fromDocument).toList(growable: false),
      );

  Future<void> update(VisitModel visit) async {
    await _visits.doc(visit.id).update(visit.toMap());
  }

  Future<void> delete(String id) async {
    await _visits.doc(id).delete();
  }

  VisitModel _fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data == null) {
      throw FormatException('Visit document "${document.id}" has no data.');
    }

    return VisitModel.fromMap({...data, 'id': document.id});
  }
}
