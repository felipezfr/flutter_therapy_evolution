import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/log/log_manager.dart';
import '../../../../core/session/session.dart';
import '../../../../core/errors/repository_exception.dart';
import '../../../../core/typedefs/result_typedef.dart';
import '../../domain/entities/patient_entity.dart';
import 'patient_repository.dart';

class PatientRepositoryImpl implements IPatientRepository {
  final FirebaseFirestore _firestore;

  PatientRepositoryImpl(this._firestore);

  @override
  OutputStream<List<PatientEntity>> getPatientsStream() {
    try {
      return _firestore
          .collection('patients')
          .where('userId', isEqualTo: Session.id)
          .where('isDeleted', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        try {
          if (snapshot.docs.isEmpty) {
            return Success([]);
          }

          final patients = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return PatientEntity.fromMap(data);
          }).toList();

          return Success(patients);
        } catch (e, s) {
          Log.error('Error processing patients snapshot',
              error: e, stackTrace: s);
          return Failure(
            RepositoryException(
              message: 'Erro ao processar dados dos pacientes',
            ),
          );
        }
      });
    } catch (e, s) {
      Log.error('Error creating patients stream', error: e, stackTrace: s);

      return Stream.value(
        Failure(
          RepositoryException(
            message: 'Erro ao criar stream de pacientes',
          ),
        ),
      );
    }
  }

  @override
  OutputStream<PatientEntity> getPatientStream(String patientId) {
    try {
      return _firestore
          .collection('patients')
          .doc(patientId)
          .snapshots()
          .map((snapshot) {
        try {
          final data = snapshot.data();
          data!['id'] = snapshot.id;
          return Success(PatientEntity.fromMap(data));
        } catch (e, s) {
          Log.error('Error processing patient snapshot',
              error: e, stackTrace: s);
          return Failure(
            RepositoryException(
              message: 'Erro ao processar dados do paciente',
            ),
          );
        }
      });
    } catch (e, s) {
      Log.error('Error creating patient stream', error: e, stackTrace: s);
      return Stream.value(
        Failure(
          RepositoryException(
            message: 'Erro ao criar stream do paciente',
          ),
        ),
      );
    }
  }

  @override
  Output<Unit> savePatient(PatientEntity patient) async {
    try {
      final saveMap = PatientEntity.toMap(patient);
      saveMap.remove('id');

      // If id is empty, create a new document with auto-generated ID
      if (patient.id.isEmpty) {
        saveMap['userId'] = Session.id;
        saveMap['isDeleted'] = false;
        saveMap['createdAt'] = DateTime.now();
        saveMap['updatedAt'] = DateTime.now();

        await _firestore.collection('patients').add(saveMap);
        return Success(unit);
      }
      // Otherwise update existing document
      else {
        saveMap['updatedAt'] = DateTime.now();
        await _firestore.collection('patients').doc(patient.id).update(saveMap);
        return Success(unit);
      }
    } catch (e, s) {
      Log.error('Error saving patient', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro ao salvar paciente',
        ),
      );
    }
  }

  @override
  Output<Unit> deletePatient(String patientId) async {
    try {
      final deleteMap = {
        'isDeleted': true,
        'deletedAt': DateTime.now(),
      };
      await _firestore.collection('patients').doc(patientId).update(deleteMap);
      return Success(unit);
    } catch (e, s) {
      Log.error('Error deleting patient', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro ao excluir paciente',
        ),
      );
    }
  }
}
