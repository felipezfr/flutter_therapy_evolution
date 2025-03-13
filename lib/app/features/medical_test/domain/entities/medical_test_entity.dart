class MedicalTestEntity {
  final String id;
  final String patientId;
  final String professionalId;
  final String? clinicalRecordId;
  final String testType;
  final String requestDate;
  final String? resultDate;
  final String? result;
  final String? resultFile;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  MedicalTestEntity({
    required this.id,
    required this.patientId,
    required this.professionalId,
    this.clinicalRecordId,
    required this.testType,
    required this.requestDate,
    this.resultDate,
    this.result,
    this.resultFile,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  MedicalTestEntity copyWith({
    String? id,
    String? patientId,
    String? professionalId,
    String? clinicalRecordId,
    String? testType,
    String? requestDate,
    String? resultDate,
    String? result,
    String? resultFile,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MedicalTestEntity(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      professionalId: professionalId ?? this.professionalId,
      clinicalRecordId: clinicalRecordId ?? this.clinicalRecordId,
      testType: testType ?? this.testType,
      requestDate: requestDate ?? this.requestDate,
      resultDate: resultDate ?? this.resultDate,
      result: result ?? this.result,
      resultFile: resultFile ?? this.resultFile,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
