class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? zipCode;
  final String? address;
  final int? numberHouse;
  final String? complement;
  final String? photoUrl;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.zipCode,
    this.address,
    this.numberHouse,
    this.complement,
    this.photoUrl,
  });
}
