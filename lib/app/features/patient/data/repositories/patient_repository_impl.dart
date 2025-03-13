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
  Output<PatientEntity> getPatient(String patientId) async {
    try {
      final docSnapshot =
          await _firestore.collection('patients').doc(patientId).get();

      if (!docSnapshot.exists) {
        return Failure(
          RepositoryException(
            message: 'Paciente não encontrado',
          ),
        );
      }

      final data = docSnapshot.data()!;
      data['id'] = docSnapshot.id;

      return Success(PatientAdapter.fromMap(data));
    } catch (e, s) {
      Log.error('Error getting patient', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro ao buscar paciente',
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
        final docRef = await _firestore.collection('patients').add(patientMap);
        final newPatient = PatientEntity(
          id: docRef.id,
          name: patient.name,
          birthDate: patient.birthDate,
          gender: patient.gender,
          documentId: patient.documentId,
          email: patient.email,
          phone: patient.phone,
          address: patient.address,
          insuranceProvider: patient.insuranceProvider,
          insuranceNumber: patient.insuranceNumber,
          responsibleProfessional: patient.responsibleProfessional,
          registrationDate: patient.registrationDate,
          notes: patient.notes,
          status: patient.status,
        );

        return Success(newPatient);
      }
      // Otherwise update existing document
      else {
        await _firestore
            .collection('patients')
            .doc(patient.id)
            .update(patientMap);
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

  @override
  Output<Unit> updatePatientStatus(String patientId, String status) async {
    try {
      await _firestore.collection('patients').doc(patientId).update({
        'status': status,
      });
      return Success(unit);
    } catch (e, s) {
      Log.error('Error updating patient status', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro ao atualizar status do paciente',
        ),
      );
    }
  }
}
