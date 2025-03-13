import '../entities/user_entity.dart';

class UserAdapter {
  static Map<String, dynamic> toMap(UserEntity user) {
    return {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'specialty': user.specialty,
      'licenseNumber': user.licenseNumber,
      'profilePicture': user.profilePicture,
      'createdAt': user.createdAt,
      'lastLogin': user.lastLogin,
    };
  }

  static UserEntity fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] ?? '',
      specialty: map['specialty'] ?? '',
      licenseNumber: map['licenseNumber'] ?? '',
      profilePicture: map['profilePicture'],
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
      lastLogin: map['lastLogin'] != null
          ? (map['lastLogin'] as dynamic).toDate()
          : DateTime,
    );
  }
}
