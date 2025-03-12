import '../entities/user_entity.dart';

class UserAdapter {
  static Map<String, dynamic> toMap(UserEntity user) {
    return {
      'id': user.id,
      'name': user.name,
      'email': user.email,
    };
  }

  static UserEntity fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }
}
