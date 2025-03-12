class AppointmentEntity {
  final String id;
  final String patientId;
  final DateTime appointmentDateTime;
  final String notes;

  AppointmentEntity({
    required this.id,
    required this.patientId,
    required this.appointmentDateTime,
    required this.notes,
  });
}
