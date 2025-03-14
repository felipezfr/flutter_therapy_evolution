import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/appointment_entity.dart';

class AppointmentAdapter {
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
