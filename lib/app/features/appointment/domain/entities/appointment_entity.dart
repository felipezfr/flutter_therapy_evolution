import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentEntity {
  final String id;
  final String patientId;
  final String date;
  final String startTime;
  final String endTime;
  final String type;
  final String status; // scheduled, confirmed, completed, canceled, noShow
  final String? notes;
  final bool reminderSent;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AppointmentEntity({
    required this.id,
    required this.patientId,
    required this.date,
    required this.startTime,
    required this.endTime,
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
      date: data['date'] ?? '',
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      type: data['type'] ?? '',
      status: data['status'] ?? 'scheduled',
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
      'startTime': entity.startTime,
      'endTime': entity.endTime,
      'type': entity.type,
      'status': entity.status,
      'notes': entity.notes,
      'reminderSent': entity.reminderSent,
    };
  }
}
