import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserRepository {
  UserRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  static const collectionName = 'users';

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(collectionName);

  Future<void> create(UserModel user) async {
    final document = _users.doc(user.id);
    await _firestore.runTransaction((transaction) async {
      final existing = await transaction.get(document);
      if (existing.exists) {
        throw StateError('A user with ID "${user.id}" already exists.');
      }

      transaction.set(document, _toDocument(user));
    });
  }

  Future<UserModel?> getById(String id) async {
    final document = await _users.doc(id).get();
    if (!document.exists) {
      return null;
    }

    return _fromDocument(document);
  }

  Future<List<UserModel>> getAll() async {
    final snapshot = await _users.get();
    return snapshot.docs.map(_fromDocument).toList(growable: false);
  }

  Future<void> update(UserModel user) async {
    await _users.doc(user.id).update(_toDocument(user));
  }

  Future<void> delete(String id) async {
    await _users.doc(id).delete();
  }

  Map<String, dynamic> _toDocument(UserModel user) => {
    'name': user.name,
    'role': user.role.name,
  };

  UserModel _fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data == null) {
      throw FormatException('User document "${document.id}" has no data.');
    }

    return UserModel.fromMap({...data, 'id': document.id});
  }
}
