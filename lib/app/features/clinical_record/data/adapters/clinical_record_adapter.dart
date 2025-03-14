import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_therapy_evolution/app/features/clinical_record/data/adapters/prescription_adapter.dart';

import '../../domain/entities/clinical_record_entity.dart';

class ClinicalRecordAdapter {
  static ClinicalRecordEntity fromMap(Map<String, dynamic> data) {
    return ClinicalRecordEntity(
      id: data['id'] ?? '',
      patientId: data['patientId'] ?? '',
      appointmentId: data['appointmentId'],
      date: data['date'] ?? '',
      chiefComplaint: data['chiefComplaint'],
      presentIllness: data['presentIllness'],
      physicalExam: data['physicalExam'],
      diagnosis: data['diagnosis'],
      plan: data['plan'],
      prescriptions: data['prescriptions'] != null
          ? (data['prescriptions'] as List)
              .map((e) => PrescriptionAdapter.fromMap(e))
              .toList()
          : null,
      recommendations: data['recommendations'],
      attachments: data['attachments'] != null
          ? List<String>.from(data['attachments'])
          : null,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  static Map<String, dynamic> toMap(ClinicalRecordEntity entity) {
    return {
      'patientId': entity.patientId,
      'appointmentId': entity.appointmentId,
      'date': entity.date,
      'chiefComplaint': entity.chiefComplaint,
      'presentIllness': entity.presentIllness,
      'physicalExam': entity.physicalExam,
      'diagnosis': entity.diagnosis,
      'plan': entity.plan,
      'prescriptions': entity.prescriptions
          ?.map((e) => PrescriptionAdapter.toMap(e))
          .toList(),
      'recommendations': entity.recommendations,
      'attachments': entity.attachments,
    };
  }
}
