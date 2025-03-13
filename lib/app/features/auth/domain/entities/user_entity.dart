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
}
