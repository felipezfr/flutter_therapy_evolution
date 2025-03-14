import '../../domain/entities/doctor_entity.dart';

class DoctorAdapter {

  static DoctorEntity fromMap(Map<String, dynamic> data) {
    return DoctorEntity(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
    );
  }

  static Map<String, dynamic> toMap(DoctorEntity entity) {  
    return {
      'id': entity.id,
      'name': entity.name,     
    };
  }
}
