import '../../domain/entities/patient_entity.dart';

class PatientAdapter {
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
      address: _addressFromMap(data['address'] ?? {}),
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
      'address': _addressToMap(entity.address),
      'insuranceProvider': entity.insuranceProvider,
      'insuranceNumber': entity.insuranceNumber,
      'responsibleProfessional': entity.responsibleProfessional,
      'registrationDate': entity.registrationDate,
      'notes': entity.notes,
      'status': entity.status,
    };
  }

  static PatientAddress _addressFromMap(Map<String, dynamic> data) {
    return PatientAddress(
      street: data['street'] ?? '',
      number: data['number'] ?? '',
      complement: data['complement'],
      district: data['district'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      zipCode: data['zipCode'] ?? '',
    );
  }

  static Map<String, dynamic> _addressToMap(PatientAddress address) {
    return {
      'street': address.street,
      'number': address.number,
      'complement': address.complement,
      'district': address.district,
      'city': address.city,
      'state': address.state,
      'zipCode': address.zipCode,
    };
  }
}
