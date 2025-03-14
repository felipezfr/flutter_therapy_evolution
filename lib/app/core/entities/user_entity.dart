class UserEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String specialty;
  final String licenseNumber;
  final String? profilePicture;
  final DateTime createdAt;
  final DateTime lastLogin;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.specialty,
    required this.licenseNumber,
    this.profilePicture,
    required this.createdAt,
    required this.lastLogin,
  });

  static UserEntity fromMap(Map<String, dynamic> data) {
    return UserEntity(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      specialty: data['specialty'] ?? '',
      licenseNumber: data['licenseNumber'] ?? '',
      profilePicture: data['profilePicture'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as dynamic).toDate()
          : DateTime.now(),
      lastLogin: data['lastLogin'] != null
          ? (data['lastLogin'] as dynamic).toDate()
          : DateTime.now(),
    );
  }

  static Map<String, dynamic> toMap(UserEntity entity) {
    return {
      'name': entity.name,
      'email': entity.email,
      'phone': entity.phone,
      'specialty': entity.specialty,
      'licenseNumber': entity.licenseNumber,
      'profilePicture': entity.profilePicture,
      'createdAt': entity.createdAt,
      'lastLogin': entity.lastLogin,
    };
  }
}
