class ConsultationEntity {
  final String id;
  final String patientId;
  final String name;

  ConsultationEntity({
    required this.id,
    required this.patientId,
    required this.name,
  });

  static ConsultationEntity fromMap(Map<String, dynamic> data) {
    return ConsultationEntity(
      id: data['id'] ?? '',
      patientId: data['patientId'],
      name: data['name'] ?? '',
    );
  }

  static Map<String, dynamic> toMap(ConsultationEntity entity) {
    return {
      'id': entity.id,
      'patientId': entity.patientId,
      'name': entity.name,
    };
  }
}
