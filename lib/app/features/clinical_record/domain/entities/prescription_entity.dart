class PrescriptionEntity {
  final String medication;
  final String dosage;
  final String frequency;
  final String duration;

  PrescriptionEntity({
    required this.medication,
    required this.dosage,
    required this.frequency,
    required this.duration,
  });

  static PrescriptionEntity fromMap(Map<String, dynamic> data) {
    return PrescriptionEntity(
      medication: data['medication'] ?? '',
      dosage: data['dosage'] ?? '',
      frequency: data['frequency'] ?? '',
      duration: data['duration'] ?? '',
    );
  }

  static Map<String, dynamic> toMap(PrescriptionEntity prescription) {
    return {
      'medication': prescription.medication,
      'dosage': prescription.dosage,
      'frequency': prescription.frequency,
      'duration': prescription.duration,
    };
  }
}
