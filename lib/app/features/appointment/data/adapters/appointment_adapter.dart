import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/appointment_entity.dart';

class AppointmentAdapter {
  static AppointmentEntity fromMap(Map<String, dynamic> data) {
    return AppointmentEntity(
      id: data['id'] ?? '',
      patientId: data['patientId'] ?? '',
      appointmentDateTime: data['appointmentDateTime'] != null
          ? (data['appointmentDateTime'] as Timestamp).toDate()
          : DateTime.now(),
      notes: data['notes'] ?? '',
    );
  }

  static Map<String, dynamic> toMap(AppointmentEntity entity) {
    return {
      'id': entity.id,
      'patientId': entity.patientId,
      'appointmentDateTime': Timestamp.fromDate(entity.appointmentDateTime),
      'notes': entity.notes,
    };
  }
}
