import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/log/log_manager.dart';
import '../../../../core/state_management/errors/base_exception.dart';
import '../../../../core/state_management/errors/repository_exception.dart';
import '../../../../core/typedefs/result_typedef.dart';
import '../../domain/entities/medical_test_entity.dart';
import '../../domain/repositories/i_medical_test_repository.dart';
import '../adapters/medical_test_adapter.dart';

class MedicalTestRepositoryImpl implements IMedicalTestRepository {
  final FirebaseFirestore _firestore;

  MedicalTestRepositoryImpl(this._firestore);

  @override
  Stream<Result<List<MedicalTestEntity>, BaseException>>
      getMedicalTestsStream() {
    try {
      return _firestore.collection('medicalTests').snapshots().map((snapshot) {
        try {
          if (snapshot.docs.isEmpty) {
            return Success([]);
          }

          final tests = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return MedicalTestAdapter.fromMap(data);
          }).toList();

          return Success(tests);
        } catch (e, s) {
          Log.error('Error processing medical tests snapshot',
              error: e, stackTrace: s);
          return Failure<List<MedicalTestEntity>, BaseException>(
            RepositoryException(
              message: 'Erro ao processar dados dos exames médicos',
            ),
          );
        }
      });
    } catch (e, s) {
      Log.error('Error creating medical tests stream', error: e, stackTrace: s);
      return Stream.value(
        Failure(
          RepositoryException(
            message: 'Erro ao criar stream de exames médicos',
          ),
        ),
      );
    }
  }

  @override
  Stream<Result<List<MedicalTestEntity>, BaseException>>
      getPatientMedicalTestsStream(String patientId) {
    try {
      return _firestore
          .collection('medicalTests')
          .where('patientId', isEqualTo: patientId)
          .snapshots()
          .map((snapshot) {
        try {
          if (snapshot.docs.isEmpty) {
            return Success([]);
          }

          final tests = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return MedicalTestAdapter.fromMap(data);
          }).toList();

          return Success(tests);
        } catch (e, s) {
          Log.error('Error processing patient medical tests snapshot',
              error: e, stackTrace: s);
          return Failure<List<MedicalTestEntity>, BaseException>(
            RepositoryException(
              message: 'Erro ao processar dados dos exames médicos do paciente',
            ),
          );
        }
      });
    } catch (e, s) {
      Log.error('Error creating patient medical tests stream',
          error: e, stackTrace: s);
      return Stream.value(
        Failure(
          RepositoryException(
            message: 'Erro ao criar stream de exames médicos do paciente',
          ),
        ),
      );
    }
  }

  @override
  Output<MedicalTestEntity> getMedicalTest(String testId) async {
    try {
      final docSnapshot =
          await _firestore.collection('medicalTests').doc(testId).get();

      if (!docSnapshot.exists) {
        return Failure(
          RepositoryException(
            message: 'Exame médico não encontrado',
          ),
        );
      }

      final data = docSnapshot.data()!;
      data['id'] = docSnapshot.id;

      return Success(MedicalTestAdapter.fromMap(data));
    } catch (e, s) {
      Log.error('Error getting medical test', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro ao buscar exame médico',
        ),
      );
    }
  }

  @override
  Output<MedicalTestEntity> saveMedicalTest(MedicalTestEntity test) async {
    try {
      final data = MedicalTestAdapter.toMap(test);

      if (test.id.isEmpty) {
        // Create new test
        final docRef = await _firestore.collection('medicalTests').add(data);
        final newTest = test.copyWith(id: docRef.id);
        return Success(newTest);
      } else {
        // Update existing test
        await _firestore.collection('medicalTests').doc(test.id).update(data);
        return Success(test);
      }
    } catch (e, s) {
      Log.error('Error saving medical test', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro ao salvar exame médico',
        ),
      );
    }
  }

  @override
  Output<Unit> deleteMedicalTest(String testId) async {
    try {
      await _firestore.collection('medicalTests').doc(testId).delete();
      return const Success(unit);
    } catch (e, s) {
      Log.error('Error deleting medical test', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro ao excluir exame médico',
        ),
      );
    }
  }
}
