import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/log/log_manager.dart';
import '../../../../core/state_management/errors/base_exception.dart';
import '../../../../core/state_management/errors/repository_exception.dart';
import '../../../../core/typedefs/result_typedef.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/repositories/i_appointment_repository.dart';
import '../adapters/appointment_adapter.dart';

class AppointmentRepositoryImpl implements IAppointmentRepository {
  final FirebaseFirestore _firestore;

  AppointmentRepositoryImpl(this._firestore);

  @override
  Output<Unit> saveAppointment(AppointmentEntity appointment) async {
    try {
      final appointmentMap = AppointmentAdapter.toMap(appointment);

      // If id is empty, create a new document with auto-generated ID
      if (appointment.id.isEmpty) {
        await _firestore.collection('appointments').add(appointmentMap);

        return Success(unit);
      }
      // Otherwise update existing document
      else {
        await _firestore
            .collection('appointments')
            .doc(appointment.id)
            .update(appointmentMap);
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
  Stream<Result<List<AppointmentEntity>, BaseException>> getAppointmentsStream(
      String userId) {
    try {
      return _firestore
          .collection('appointments')
          .where('professionalId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        try {
          if (snapshot.docs.isEmpty) {
            return Success([]);
          }

          final appointments = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return AppointmentAdapter.fromMap(data);
          }).toList();

          return Success(appointments);
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
  Output<Unit> deleteAppointment(String appointmentId) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).delete();
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
  Stream<Result<List<AppointmentEntity>, BaseException>>
      getPatientAppointmentsStream(String patientId) {
    try {
      return _firestore
          .collection('appointments')
          .where('patientId', isEqualTo: patientId)
          .snapshots()
          .map((snapshot) {
        try {
          if (snapshot.docs.isEmpty) {
            return Success([]);
          }

          final appointments = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return AppointmentAdapter.fromMap(data);
          }).toList();

          return Success(appointments);
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
}
