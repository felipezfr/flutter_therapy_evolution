import '../entities/patient_entity.dart';

class PatientAdapter {
  Map<String, dynamic> toMap(PatientEntity patient) {
    return {
      'id': patient.id,
      'name': patient.name,
    };
  }

  PatientEntity fromMap(Map<String, dynamic> map) {
    return PatientEntity(
      map['id'] as String,
      map['name'] as String,
    );
  }
}
