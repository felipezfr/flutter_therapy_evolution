import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/log/log_manager.dart';
import '../../../../core/state_management/errors/base_exception.dart';
import '../../../../core/state_management/errors/repository_exception.dart';
import '../../../../core/typedefs/result_typedef.dart';
import '../../domain/entities/patient_entity.dart';
import '../../domain/repositories/i_patient_repository.dart';
import '../adapters/patient_adapter.dart';

class PatientRepositoryImpl implements IPatientRepository {
  final FirebaseFirestore _firestore;

  PatientRepositoryImpl(this._firestore);

  @override
  Stream<Result<List<PatientEntity>, BaseException>> getPatientsStream() {
    try {
      return _firestore.collection('patients').snapshots().map((snapshot) {
        try {
          if (snapshot.docs.isEmpty) {
            return Success([]);
          }

          final patients = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return PatientAdapter.fromMap(data);
          }).toList();

          return Success(patients);
        } catch (e, s) {
          Log.error('Error processing patients snapshot',
              error: e, stackTrace: s);
          return Failure<List<PatientEntity>, BaseException>(
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
  Output<PatientEntity> savePatient(PatientEntity patient) async {
    try {
      final patientMap = PatientAdapter.toMap(patient);

      // If id is empty, create a new document with auto-generated ID
      if (patient.id.isEmpty) {
        final docRef = _firestore.collection('patients').doc();
        final newPatient = PatientEntity(
          id: docRef.id,
          name: patient.name,
        );

        await docRef.set(PatientAdapter.toMap(newPatient));
        return Success(newPatient);
      }
      // Otherwise update existing document
      else {
        await _firestore.collection('patients').doc(patient.id).set(patientMap);
        return Success(patient);
      }
    } on FirebaseAuthException catch (e, s) {
      Log.error('Error saving patient', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: e.message ?? 'Erro ao salvar paciente',
        ),
      );
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
      await _firestore.collection('patients').doc(patientId).delete();
      return Success(unit);
    } on FirebaseAuthException catch (e, s) {
      Log.error('Error deleting patient', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: e.message ?? 'Erro ao excluir paciente',
        ),
      );
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
