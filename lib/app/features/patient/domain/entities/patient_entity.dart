import 'patient_address_entity.dart';

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

  static PatientEntity fromMap(Map<String, dynamic> data) {
    return PatientEntity(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      birthDate: data['birthDate'] != null
          ? (data['birthDate'] as dynamic).toDate()
          : DateTime.now(),
      gender: data['gender'] ?? '',
      documentId: data['documentId'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      address: PatientAddress.fromMap(data['address'] ?? {}),
      insuranceProvider: data['insuranceProvider'],
      insuranceNumber: data['insuranceNumber'],
      responsibleProfessional: data['responsibleProfessional'] ?? '',
      registrationDate: data['registrationDate'] != null
          ? (data['registrationDate'] as dynamic).toDate()
          : DateTime.now(),
      notes: data['notes'],
      status: data['status'] ?? 'active',
    );
  }

  static Map<String, dynamic> toMap(PatientEntity entity) {
    return {
      'name': entity.name,
      'birthDate': entity.birthDate,
      'gender': entity.gender,
      'documentId': entity.documentId,
      'email': entity.email,
      'phone': entity.phone,
      'address': PatientAddress.toMap(entity.address),
      'insuranceProvider': entity.insuranceProvider,
      'insuranceNumber': entity.insuranceNumber,
      'responsibleProfessional': entity.responsibleProfessional,
      'registrationDate': entity.registrationDate,
      'notes': entity.notes,
      'status': entity.status,
    };
  }
}
