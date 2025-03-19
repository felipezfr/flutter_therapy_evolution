import 'package:cloud_firestore/cloud_firestore.dart';

import 'appointment_status_enum.dart';

class AppointmentEntity {
  final String id;
  final String patientId;
  final DateTime date;
  final int durationMinutes;
  final String type;
  final AppointmentStatus status;
  final String? notes;
  final bool reminderSent;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AppointmentEntity({
    required this.id,
    required this.patientId,
    required this.date,
    required this.durationMinutes,
    required this.type,
    required this.status,
    this.notes,
    required this.reminderSent,
    this.createdAt,
    this.updatedAt,
  });

  static AppointmentEntity fromMap(Map<String, dynamic> data) {
    return AppointmentEntity(
      id: data['id'] ?? '',
      patientId: data['patientId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      durationMinutes: data['durationMinutes'],
      type: data['type'] ?? '',
      status: AppointmentStatus.fromString(data['status']),
      notes: data['notes'],
      reminderSent: data['reminderSent'] ?? false,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  static Map<String, dynamic> toMap(AppointmentEntity entity) {
    return {
      'patientId': entity.patientId,
      'date': entity.date,
      'durationMinutes': entity.durationMinutes,
      'type': entity.type,
      'status': entity.status.value,
      'notes': entity.notes,
      'reminderSent': entity.reminderSent,
    };
  }
}
