import 'package:shared_preferences/shared_preferences.dart';

import '../models/dummy_data.dart';
import '../models/user_model.dart';

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthService {
  static const _userIdKey = 'clinic_user_id';
  static const _invalidCredentialsMessage = 'Incorrect ID number or password.';
  static UserModel? _currentUser;

  Future<UserModel> login(String id, String password) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final normalizedId = id.trim();
    final record = _findRecord(normalizedId);

    if (record == null || record.password != password) {
      throw const AuthException(_invalidCredentialsMessage);
    }

    final user = record.toUserModel();
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(_userIdKey, user.id);
    if (!saved) {
      throw StateError('Unable to save the login session.');
    }

    _currentUser = user;
    return user;
  }

  Future<void> logout() async {
    _currentUser = null;
    final preferences = await SharedPreferences.getInstance();
    final removed = await preferences.remove(_userIdKey);
    if (!removed) {
      throw StateError('Unable to clear the login session.');
    }
  }

  Future<UserModel?> getCurrentUser({UserRole? requiredRole}) async {
    final preferences = await SharedPreferences.getInstance();
    final id = preferences.getString(_userIdKey);
    if (id == null) {
      _currentUser = null;
      return null;
    }

    final record = _findRecord(id);

    if (record == null ||
        (requiredRole != null && record.role != requiredRole)) {
      _currentUser = null;
      final removed = await preferences.remove(_userIdKey);
      if (!removed) {
        throw StateError('Unable to clear the invalid login session.');
      }
      return null;
    }

    if (_currentUser?.id != id) {
      _currentUser = record.toUserModel();
    }
    return _currentUser;
  }

  Future<UserModel?> restoreSession() => getCurrentUser();

  DummyUserRecord? _findRecord(String id) {
    for (final record in dummyUsers) {
      if (record.id == id) {
        return record;
      }
    }
    return null;
  }
}
