import '../../domain/entities/home_entity.dart';

class HomeAdapter {

  static HomeEntity fromMap(Map<String, dynamic> data) {
    return HomeEntity(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
    );
  }

  static Map<String, dynamic> toMap(HomeEntity entity) {  
    return {
      'id': entity.id,
      'name': entity.name,     
    };
  }
}
