import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/log/log_manager.dart';
import '../../../../core/state_management/errors/base_exception.dart';
import '../../../../core/state_management/errors/repository_exception.dart';
import '../../../../core/typedefs/result_typedef.dart';
import '../../domain/entities/clinical_record_entity.dart';
import '../../domain/repositories/i_clinical_record_repository.dart';
import '../adapters/clinical_record_adapter.dart';

class ClinicalRecordRepositoryImpl implements IClinicalRecordRepository {
  final FirebaseFirestore _firestore;

  ClinicalRecordRepositoryImpl(this._firestore);

  @override
  Stream<Result<List<ClinicalRecordEntity>, BaseException>>
      getClinicalRecordsStream() {
    try {
      return _firestore
          .collection('clinicalRecords')
          .snapshots()
          .map((snapshot) {
        try {
          if (snapshot.docs.isEmpty) {
            return Success([]);
          }

          final records = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return ClinicalRecordAdapter.fromMap(data);
          }).toList();

          return Success(records);
        } catch (e, s) {
          Log.error('Error processing clinical records snapshot',
              error: e, stackTrace: s);
          return Failure<List<ClinicalRecordEntity>, BaseException>(
            RepositoryException(
              message: 'Erro ao processar dados dos registros clínicos',
            ),
          );
        }
      });
    } catch (e, s) {
      Log.error('Error creating clinical records stream',
          error: e, stackTrace: s);
      return Stream.value(
        Failure(
          RepositoryException(
            message: 'Erro ao criar stream de registros clínicos',
          ),
        ),
      );
    }
  }

  @override
  Stream<Result<List<ClinicalRecordEntity>, BaseException>>
      getPatientClinicalRecordsStream(String patientId) {
    try {
      return _firestore
          .collection('clinicalRecords')
          .where('patientId', isEqualTo: patientId)
          .snapshots()
          .map((snapshot) {
        try {
          if (snapshot.docs.isEmpty) {
            return Success([]);
          }

          final records = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return ClinicalRecordAdapter.fromMap(data);
          }).toList();

          return Success(records);
        } catch (e, s) {
          Log.error('Error processing patient clinical records snapshot',
              error: e, stackTrace: s);
          return Failure<List<ClinicalRecordEntity>, BaseException>(
            RepositoryException(
              message:
                  'Erro ao processar dados dos registros clínicos do paciente',
            ),
          );
        }
      });
    } catch (e, s) {
      Log.error('Error creating patient clinical records stream',
          error: e, stackTrace: s);
      return Stream.value(
        Failure(
          RepositoryException(
            message: 'Erro ao criar stream de registros clínicos do paciente',
          ),
        ),
      );
    }
  }

  @override
  Output<ClinicalRecordEntity> getClinicalRecord(String recordId) async {
    try {
      final docSnapshot =
          await _firestore.collection('clinicalRecords').doc(recordId).get();

      if (!docSnapshot.exists) {
        return Failure(
          RepositoryException(
            message: 'Registro clínico não encontrado',
          ),
        );
      }

      final data = docSnapshot.data()!;
      data['id'] = docSnapshot.id;

      return Success(ClinicalRecordAdapter.fromMap(data));
    } catch (e, s) {
      Log.error('Error getting clinical record', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro ao buscar registro clínico',
        ),
      );
    }
  }

  @override
  Output<void> saveClinicalRecord(ClinicalRecordEntity record) async {
    try {
      final data = ClinicalRecordAdapter.toMap(record);

      if (record.id.isEmpty) {
        // Create new record
        await _firestore.collection('clinicalRecords').add(data);
        return Success(unit);
      } else {
        // Update existing record
        await _firestore
            .collection('clinicalRecords')
            .doc(record.id)
            .update(data);
        return Success(unit);
      }
    } catch (e, s) {
      Log.error('Error saving clinical record', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro ao salvar registro clínico',
        ),
      );
    }
  }

  @override
  Output<Unit> deleteClinicalRecord(String recordId) async {
    try {
      await _firestore.collection('clinicalRecords').doc(recordId).delete();
      return const Success(unit);
    } catch (e, s) {
      Log.error('Error deleting clinical record', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro ao excluir registro clínico',
        ),
      );
    }
  }
}
