import 'package:cloud_firestore/cloud_firestore.dart';

import 'prescription_entity.dart';

class ClinicalRecordEntity {
  final String id;
  final String patientId;
  final String? appointmentId;
  final DateTime date;
  final String? chiefComplaint;
  final String? presentIllness;
  final String? physicalExam;
  final String? diagnosis;
  final String? plan;
  final List<PrescriptionEntity>? prescriptions;
  final String? recommendations;
  final List<String>? attachments;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ClinicalRecordEntity({
    required this.id,
    required this.patientId,
    this.appointmentId,
    required this.date,
    this.chiefComplaint,
    this.presentIllness,
    this.physicalExam,
    this.diagnosis,
    this.plan,
    this.prescriptions,
    this.recommendations,
    this.attachments,
    this.createdAt,
    this.updatedAt,
  });

  static ClinicalRecordEntity fromMap(Map<String, dynamic> data) {
    return ClinicalRecordEntity(
      id: data['id'] ?? '',
      patientId: data['patientId'] ?? '',
      appointmentId: data['appointmentId'],
      date: (data['date'] as Timestamp).toDate(),
      chiefComplaint: data['chiefComplaint'],
      presentIllness: data['presentIllness'],
      physicalExam: data['physicalExam'],
      diagnosis: data['diagnosis'],
      plan: data['plan'],
      prescriptions: data['prescriptions'] != null
          ? (data['prescriptions'] as List)
              .map((e) => PrescriptionEntity.fromMap(e))
              .toList()
          : null,
      recommendations: data['recommendations'],
      attachments: data['attachments'] != null
          ? List<String>.from(data['attachments'])
          : null,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
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
          ?.map((e) => PrescriptionEntity.toMap(e))
          .toList(),
      'recommendations': entity.recommendations,
      'attachments': entity.attachments,
    };
  }
}
