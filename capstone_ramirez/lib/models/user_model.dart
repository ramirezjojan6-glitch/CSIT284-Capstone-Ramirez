enum UserRole { student, nurse }

extension UserRoleLabel on UserRole {
  String get label => switch (this) {
    UserRole.student => 'Student',
    UserRole.nurse => 'Nurse',
  };
}

class UserModel {
  const UserModel({required this.id, required this.name, required this.role});

  final String id;
  final String name;
  final UserRole role;

  factory UserModel.fromMap(Map<String, Object?> map) {
    final id = map['id'];
    final name = map['name'];
    final roleName = map['role'];

    if (id is! String || name is! String || roleName is! String) {
      throw const FormatException('Invalid user record.');
    }

    final role = UserRole.values.firstWhere(
      (candidate) => candidate.name == roleName,
      orElse: () => throw FormatException('Unknown user role: $roleName'),
    );

    return UserModel(id: id, name: name, role: role);
  }

  Map<String, Object?> toMap() => {'id': id, 'name': name, 'role': role.name};
}
