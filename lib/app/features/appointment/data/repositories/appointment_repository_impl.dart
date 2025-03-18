import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/log/log_manager.dart';
import '../../../../core/session/logged_user.dart';
import '../../../../core/errors/repository_exception.dart';
import '../../../../core/typedefs/result_typedef.dart';
import '../../domain/entities/appointment_entity.dart';
import 'appointment_repository.dart';

class AppointmentRepositoryImpl implements IAppointmentRepository {
  final FirebaseFirestore _firestore;

  AppointmentRepositoryImpl(this._firestore);

  final String loggedUserId = LoggedUser.id;

  @override
  OutputStream<List<AppointmentEntity>> getAllAppointmentsStream() {
    try {
      // Timestamp dataInicio = Timestamp.fromDate(
      //   DateTime(2025, 2, 13),
      // );
      // Timestamp dataFim = Timestamp.fromDate(
      //   DateTime(2025, 5, 18, 23, 59, 59),
      // );

      return _firestore
          .collection('appointments')
          .where('userId', isEqualTo: LoggedUser.id)
          .where('isDeleted', isEqualTo: false)
          // .where('data', isGreaterThanOrEqualTo: dataInicio)
          // .where('data', isLessThanOrEqualTo: dataFim)
          .orderBy('createdAt', descending: true)
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
}
