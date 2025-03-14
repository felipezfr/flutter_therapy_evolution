class HomeEntity {
  final String id;
  final String name;

  HomeEntity({
    required this.id,
    required this.name,
  });

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
