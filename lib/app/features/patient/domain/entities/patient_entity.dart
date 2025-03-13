class PatientEntity {
  final String id;
  final String name;
  final DateTime birthDate;
  final String gender;
  final String documentId;
  final String email;
  final String phone;
  final PatientAddress address;
  final String? insuranceProvider;
  final String? insuranceNumber;
  final String responsibleProfessional;
  final DateTime registrationDate;
  final String? notes;
  final String status; // active, inactive

  PatientEntity({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.documentId,
    required this.email,
    required this.phone,
    required this.address,
    this.insuranceProvider,
    this.insuranceNumber,
    required this.responsibleProfessional,
    required this.registrationDate,
    this.notes,
    required this.status,
  });
}

class PatientAddress {
  final String street;
  final String number;
  final String? complement;
  final String district;
  final String city;
  final String state;
  final String zipCode;

  PatientAddress({
    required this.street,
    required this.number,
    this.complement,
    required this.district,
    required this.city,
    required this.state,
    required this.zipCode,
  });
}
