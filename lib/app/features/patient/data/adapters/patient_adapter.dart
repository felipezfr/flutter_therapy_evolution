import '../../domain/entities/patient_entity.dart';

class PatientAdapter {
  static PatientEntity fromMap(Map<String, dynamic> data) {
    return PatientEntity(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
    );
  }

  static Map<String, dynamic> toMap(PatientEntity entity) {
    return {
      'id': entity.id,
      'name': entity.name,
    };
  }
}
