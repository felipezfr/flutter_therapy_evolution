import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/log/log_manager.dart';
import '../../../../core/session/logged_user.dart';
import '../../../../core/errors/base_exception.dart';
import '../../../../core/errors/repository_exception.dart';
import '../../../../core/typedefs/result_typedef.dart';
import '../../domain/entities/clinical_record_entity.dart';
import 'i_clinical_record_repository.dart';

class ClinicalRecordRepositoryImpl implements IClinicalRecordRepository {
  final FirebaseFirestore _firestore;

  ClinicalRecordRepositoryImpl(this._firestore);

  @override
  OutputStream<List<ClinicalRecordEntity>> getClinicalRecordsStream() {
    try {
      return _firestore
          .collection('clinicalRecords')
          .where('userId', isEqualTo: LoggedUser.id)
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
            return ClinicalRecordEntity.fromMap(data);
          }).toList();

          return Success(doctors);
        } catch (e, s) {
          Log.error('Error processing clinical snapshot',
              error: e, stackTrace: s);
          return Failure(
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
          .where('userId', isEqualTo: LoggedUser.id)
          .where('isDeleted', isEqualTo: false)
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
            return ClinicalRecordEntity.fromMap(data);
          }).toList();

          return Success(records);
        } catch (e, s) {
          Log.error('Error processing patient clinical records snapshot',
              error: e, stackTrace: s);
          return Failure(
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
  Output<Unit> saveClinicalRecord(ClinicalRecordEntity record) async {
    try {
      final saveMap = ClinicalRecordEntity.toMap(record);
      saveMap.remove('id');

      // If id is empty, create a new document with auto-generated ID
      if (record.id.isEmpty) {
        saveMap['userId'] = LoggedUser.id;
        saveMap['isDeleted'] = false;
        saveMap['createdAt'] = DateTime.now();
        saveMap['updatedAt'] = DateTime.now();

        await _firestore.collection('clinicalRecords').add(saveMap);
        return Success(unit);
      }
      // update existing document
      else {
        saveMap['updatedAt'] = DateTime.now();
        await _firestore
            .collection('clinicalRecords')
            .doc(record.id)
            .update(saveMap);
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
      final deleteMap = {
        'isDeleted': true,
        'deletedAt': DateTime.now(),
      };
      await _firestore
          .collection('clinicalRecords')
          .doc(recordId)
          .update(deleteMap);
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
