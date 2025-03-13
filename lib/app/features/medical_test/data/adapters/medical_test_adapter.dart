import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/medical_test_entity.dart';

class MedicalTestAdapter {
  static MedicalTestEntity fromMap(Map<String, dynamic> data) {
    return MedicalTestEntity(
      id: data['id'] ?? '',
      patientId: data['patientId'] ?? '',
      professionalId: data['professionalId'] ?? '',
      clinicalRecordId: data['clinicalRecordId'],
      testType: data['testType'] ?? '',
      requestDate: data['requestDate'] ?? '',
      resultDate: data['resultDate'],
      result: data['result'],
      resultFile: data['resultFile'],
      notes: data['notes'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  static Map<String, dynamic> toMap(MedicalTestEntity entity) {
    return {
      'patientId': entity.patientId,
      'professionalId': entity.professionalId,
      'clinicalRecordId': entity.clinicalRecordId,
      'testType': entity.testType,
      'requestDate': entity.requestDate,
      'resultDate': entity.resultDate,
      'result': entity.result,
      'resultFile': entity.resultFile,
      'notes': entity.notes,
      'createdAt': Timestamp.fromDate(entity.createdAt),
      'updatedAt': Timestamp.fromDate(entity.updatedAt),
    };
  }
}
