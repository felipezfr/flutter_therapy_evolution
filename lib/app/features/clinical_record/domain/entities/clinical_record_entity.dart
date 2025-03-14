import 'prescription_entity.dart';

class ClinicalRecordEntity {
  final String id;
  final String patientId;
  final String? appointmentId;
  final String date;
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
}
