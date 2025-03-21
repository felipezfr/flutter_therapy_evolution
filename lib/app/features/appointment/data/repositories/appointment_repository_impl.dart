import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/log/log_manager.dart';
import '../../../../core/session/logged_user.dart';
import '../../../../core/errors/repository_exception.dart';
import '../../../../core/typedefs/result_typedef.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/enums/recurrence_type_enum.dart';
import 'appointment_repository.dart';

class AppointmentRepositoryImpl implements IAppointmentRepository {
  final FirebaseFirestore _firestore;

  AppointmentRepositoryImpl(this._firestore);

  final String loggedUserId = LoggedUser.id;

  @override
  OutputStream<List<AppointmentEntity>> getAllAppointmentsStream(
      int year, int month) {
    try {
      final dateInit = DateTime(year, month);
      final dateEnd = DateTime(year, month + 1, 0, 23, 59, 59);

      Timestamp dataInicio = Timestamp.fromDate(dateInit);
      Timestamp dataFim = Timestamp.fromDate(dateEnd);

      return _firestore
          .collection('appointments')
          .where('userId', isEqualTo: LoggedUser.id)
          .where('isDeleted', isEqualTo: false)
          .where('date', isGreaterThanOrEqualTo: dataInicio)
          .where('date', isLessThanOrEqualTo: dataFim)
          .orderBy('createdAt', descending: false)
          .snapshots()
          .map((snapshot) {
        try {
          if (snapshot.docs.isEmpty) {
            return Success([]);
          }

          final doctors = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return AppointmentEntity.fromMap(data);
          }).toList();

          return Success(doctors);
        } catch (e, s) {
          Log.error('Error processing appointments snapshot',
              error: e, stackTrace: s);
          return Failure(
            RepositoryException(
              message: 'Erro ao processar dados dos agendamentos',
            ),
          );
        }
      });
    } catch (e, s) {
      Log.error('Error creating appointments stream', error: e, stackTrace: s);
      return Stream.value(
        Failure(
          RepositoryException(
            message: 'Erro ao criar stream de agendamentos',
          ),
        ),
      );
    }
  }

  @override
  OutputStream<AppointmentEntity> getAppointmentStream(String appointmentId) {
    try {
      return _firestore
          .collection('appointments')
          .doc(appointmentId)
          .snapshots()
          .map((snapshot) {
        try {
          final data = snapshot.data();
          data!['id'] = snapshot.id;
          return Success(AppointmentEntity.fromMap(data));
        } catch (e, s) {
          Log.error('Error processing appointment snapshot',
              error: e, stackTrace: s);
          return Failure(
            RepositoryException(
              message: 'Erro ao processar dados do agendamento',
            ),
          );
        }
      });
    } catch (e, s) {
      Log.error('Error creating appointment stream', error: e, stackTrace: s);
      return Stream.value(
        Failure(
          RepositoryException(
            message: 'Erro ao criar stream do agendamento',
          ),
        ),
      );
    }
  }

  @override
  OutputStream<List<AppointmentEntity>> getPatientAppointmentsStream(
      String patientId) {
    try {
      return _firestore
          .collection('appointments')
          .where('userId', isEqualTo: LoggedUser.id)
          .where('patientId', isEqualTo: patientId)
          .where('isDeleted', isEqualTo: false)
          .orderBy('date', descending: true)
          .snapshots()
          .map((snapshot) {
        try {
          if (snapshot.docs.isEmpty) {
            return Success([]);
          }

          final doctors = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return AppointmentEntity.fromMap(data);
          }).toList();

          return Success(doctors);
        } catch (e, s) {
          Log.error('Error processing appointments snapshot',
              error: e, stackTrace: s);
          return Failure(
            RepositoryException(
              message: 'Erro ao processar dados dos agendamentos',
            ),
          );
        }
      });
    } catch (e, s) {
      Log.error('Error creating appointments stream', error: e, stackTrace: s);
      return Stream.value(
        Failure(
          RepositoryException(
            message: 'Erro ao criar stream de agendamentos',
          ),
        ),
      );
    }
  }

  @override
  Output<Unit> saveAppointment(AppointmentEntity appointment) async {
    try {
      final saveMap = AppointmentEntity.toMap(appointment);
      saveMap.remove('id');

      // If id is empty, create a new document with auto-generated ID
      if (appointment.id.isEmpty) {
        saveMap['userId'] = LoggedUser.id;
        saveMap['isDeleted'] = false;
        saveMap['createdAt'] = DateTime.now();
        saveMap['updatedAt'] = DateTime.now();

        await _firestore.collection('appointments').add(saveMap);
        return Success(unit);
      }
      // update existing document
      else {
        saveMap['updatedAt'] = DateTime.now();
        await _firestore
            .collection('appointments')
            .doc(appointment.id)
            .update(saveMap);
        return Success(unit);
      }
    } catch (e, s) {
      Log.error('Error saving appointment', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro ao salvar agendamento',
        ),
      );
    }
  }

  @override
  Output<Unit> deleteAppointment(String appointmentId) async {
    try {
      final deleteMap = {
        'isDeleted': true,
        'deletedAt': DateTime.now(),
      };
      await _firestore
          .collection('appointments')
          .doc(appointmentId)
          .update(deleteMap);
      return Success(unit);
    } catch (e, s) {
      Log.error('Error deleting appointment', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro ao excluir agendamento',
        ),
      );
    }
  }

  @override
  Output<Unit> saveRecurringAppointments(AppointmentEntity appointment,
      RecurrenceType recurrenceType, int count) async {
    try {
      if (count <= 0) {
        return Failure(
          RepositoryException(
            message: 'O número de recorrências deve ser maior que zero',
          ),
        );
      }

      // Generate a group ID for all recurring appointments
      final recurringGroupId = const Uuid().v4();

      // Create a batch to save all appointments at once
      final batch = _firestore.batch();

      for (int i = 0; i < count; i++) {
        // Calculate the date for this occurrence based on recurrence type
        final DateTime occurrenceDate = _calculateRecurrenceDate(
          appointment.date,
          recurrenceType,
          i,
        );

        // Create a new appointment entity for this occurrence
        final appointmentData = AppointmentEntity.toMap(
          AppointmentEntity(
            id: '',
            patientId: appointment.patientId,
            date: occurrenceDate,
            durationMinutes: appointment.durationMinutes,
            type: appointment.type,
            status: appointment.status,
            notes: appointment.notes,
            reminderSent: false,
            recurrenceType: recurrenceType,
            recurrenceCount: count,
            recurringGroupId: recurringGroupId,
          ),
        );

        // Add common fields
        appointmentData['userId'] = LoggedUser.id;
        appointmentData['isDeleted'] = false;
        appointmentData['createdAt'] = DateTime.now();
        appointmentData['updatedAt'] = DateTime.now();

        // Add this appointment to the batch
        final docRef = _firestore.collection('appointments').doc();
        batch.set(docRef, appointmentData);
      }

      // Commit the batch
      await batch.commit();
      return Success(unit);
    } catch (e, s) {
      Log.error('Error saving recurring appointments', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro ao salvar agendamentos recorrentes',
        ),
      );
    }
  }

  @override
  Output<Unit> deleteRecurringAppointments(String recurringGroupId) async {
    try {
      // Get all appointments with the specified recurring group ID
      final querySnapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: LoggedUser.id)
          .where('recurringGroupId', isEqualTo: recurringGroupId)
          .where('isDeleted', isEqualTo: false)
          .get();

      // If no appointments found, return success
      if (querySnapshot.docs.isEmpty) {
        return Success(unit);
      }

      // Create a batch to delete all appointments at once
      final batch = _firestore.batch();

      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {
          'isDeleted': true,
          'deletedAt': DateTime.now(),
        });
      }

      // Commit the batch
      await batch.commit();
      return Success(unit);
    } catch (e, s) {
      Log.error('Error deleting recurring appointments',
          error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro ao excluir agendamentos recorrentes',
        ),
      );
    }
  }

  DateTime _calculateRecurrenceDate(
      DateTime baseDate, RecurrenceType recurrenceType, int index) {
    if (index == 0) {
      return baseDate; // First occurrence is the original date
    }

    switch (recurrenceType) {
      case RecurrenceType.daily:
        return baseDate.add(Duration(days: index));
      case RecurrenceType.weekly:
        return baseDate.add(Duration(days: 7 * index));
      case RecurrenceType.biweekly:
        return baseDate.add(Duration(days: 14 * index));
      case RecurrenceType.monthly:
        // Add months by calculating new date
        int year = baseDate.year;
        int month = baseDate.month + index;

        // Adjust for overflow
        year += (month - 1) ~/ 12;
        month = ((month - 1) % 12) + 1;

        // Create a new DateTime with the same day, hour, minute, second
        return DateTime(
          year,
          month,
          baseDate.day, // This might need adjustment for months with fewer days
          baseDate.hour,
          baseDate.minute,
          baseDate.second,
        );
      case RecurrenceType.none:
        return baseDate;
    }
  }
}
