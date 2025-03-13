import 'prescription_entity.dart';

class ClinicalRecordEntity {
  final String id;
  final String patientId;
  final String professionalId;
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
  final DateTime createdAt;
  final DateTime updatedAt;

  ClinicalRecordEntity({
    required this.id,
    required this.patientId,
    required this.professionalId,
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
    required this.createdAt,
    required this.updatedAt,
  });

  ClinicalRecordEntity copyWith({
    String? id,
    String? patientId,
    String? professionalId,
    String? appointmentId,
    String? date,
    String? chiefComplaint,
    String? presentIllness,
    String? physicalExam,
    String? diagnosis,
    String? plan,
    List<PrescriptionEntity>? prescriptions,
    String? recommendations,
    List<String>? attachments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClinicalRecordEntity(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      professionalId: professionalId ?? this.professionalId,
      appointmentId: appointmentId ?? this.appointmentId,
      date: date ?? this.date,
      chiefComplaint: chiefComplaint ?? this.chiefComplaint,
      presentIllness: presentIllness ?? this.presentIllness,
      physicalExam: physicalExam ?? this.physicalExam,
      diagnosis: diagnosis ?? this.diagnosis,
      plan: plan ?? this.plan,
      prescriptions: prescriptions ?? this.prescriptions,
      recommendations: recommendations ?? this.recommendations,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
