class AppointmentEntity {
  final String id;
  final String patientId;
  final String professionalId;
  final String date;
  final String startTime;
  final String endTime;
  final String type;
  final String status; // scheduled, confirmed, completed, canceled, noShow
  final String? notes;
  final bool reminderSent;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppointmentEntity({
    required this.id,
    required this.patientId,
    required this.professionalId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.status,
    this.notes,
    required this.reminderSent,
    required this.createdAt,
    required this.updatedAt,
  });
}
