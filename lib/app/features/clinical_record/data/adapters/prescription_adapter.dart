import '../../domain/entities/prescription_entity.dart';

class PrescriptionAdapter {
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
