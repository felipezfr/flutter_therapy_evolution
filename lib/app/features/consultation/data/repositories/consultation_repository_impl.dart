import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/errors/repository_exception.dart';
import '../../../../core/log/log_manager.dart';
import '../../../../core/session/session.dart';
import '../../../../core/typedefs/result_typedef.dart';
import '../../domain/entities/consultation_entity.dart';
import 'consultation_repository.dart';

class ConsultationRepositoryImpl implements IConsultationRepository {
  final FirebaseFirestore _firestore;

  ConsultationRepositoryImpl(this._firestore);

  final String loggedUserId = Session.id;

  @override
  OutputStream<List<ConsultationEntity>> getConsultationsStream() {
    try {
      return _firestore
          .collection('consultations')
          .where('userId', isEqualTo: Session.id)
          .where('isDeleted', isEqualTo: false)
          .snapshots()
          .map((snapshot) {
        try {
          if (snapshot.docs.isEmpty) {
            return Success([]);
          }

          final consultations = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return ConsultationEntity.fromMap(data);
          }).toList();

          return Success(consultations);
        } catch (e, s) {
          Log.error('Error processing consultations snapshot',
              error: e, stackTrace: s);
          return Failure(
            RepositoryException(
              message: 'Erro ao processar dados dos consultations',
            ),
          );
        }
      });
    } catch (e, s) {
      Log.error('Error creating consultations stream', error: e, stackTrace: s);
      return Stream.value(
        Failure(
          RepositoryException(
            message: 'Erro ao criar stream de consultations',
          ),
        ),
      );
    }
  }

  @override
  OutputStream<List<ConsultationEntity>> getPatientConsultationsStream(
      String patientId) {
    try {
      return _firestore
          .collection('consultations')
          .where('userId', isEqualTo: Session.id)
          .where('patientId', isEqualTo: patientId)
          .where('isDeleted', isEqualTo: false)
          .snapshots()
          .map((snapshot) {
        try {
          if (snapshot.docs.isEmpty) {
            return Success([]);
          }

          final consultations = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return ConsultationEntity.fromMap(data);
          }).toList();

          return Success(consultations);
        } catch (e, s) {
          Log.error('Error processing patient consultations snapshot',
              error: e, stackTrace: s);
          return Failure(
            RepositoryException(
              message: 'Erro ao processar dados das consultas do paciente',
            ),
          );
        }
      });
    } catch (e, s) {
      Log.error('Error creating patient consultations stream',
          error: e, stackTrace: s);
      return Stream.value(
        Failure(
          RepositoryException(
            message: 'Erro ao criar stream das consultas do paciente',
          ),
        ),
      );
    }
  }

  @override
  OutputStream<ConsultationEntity> getConsultationStream(
      String consultationId) {
    try {
      return _firestore
          .collection('consultations')
          .doc(consultationId)
          .snapshots()
          .map((snapshot) {
        try {
          final data = snapshot.data();
          data!['id'] = snapshot.id;
          return Success(ConsultationEntity.fromMap(data));
        } catch (e, s) {
          Log.error('Error processing consultation snapshot',
              error: e, stackTrace: s);
          return Failure(
            RepositoryException(
              message: 'Erro ao processar dados do consultation',
            ),
          );
        }
      });
    } catch (e, s) {
      Log.error('Error creating consultation stream', error: e, stackTrace: s);
      return Stream.value(
        Failure(
          RepositoryException(
            message: 'Erro ao criar stream de consultation',
          ),
        ),
      );
    }
  }

  @override
  Output<Unit> saveConsultation(ConsultationEntity consultation) async {
    try {
      final saveMap = ConsultationEntity.toMap(consultation);
      saveMap.remove('id');

      // If id is empty, create a new document with auto-generated ID
      if (consultation.id.isEmpty) {
        saveMap['userId'] = Session.id;
        saveMap['isDeleted'] = false;
        saveMap['createdAt'] = DateTime.now();
        saveMap['updatedAt'] = DateTime.now();

        await _firestore.collection('consultations').add(saveMap);
        return Success(unit);
      }
      // update existing document
      else {
        saveMap['updatedAt'] = DateTime.now();
        await _firestore
            .collection('consultations')
            .doc(consultation.id)
            .update(saveMap);
        return Success(unit);
      }
    } catch (e, s) {
      Log.error('Error saving consultation', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro ao salvar consultation',
        ),
      );
    }
  }

  @override
  Output<Unit> deleteConsultation(String consultationId) async {
    try {
      final deleteMap = {
        'isDeleted': true,
        'deletedAt': DateTime.now(),
      };
      await _firestore
          .collection('consultations')
          .doc(consultationId)
          .update(deleteMap);
      return Success(unit);
    } catch (e, s) {
      Log.error('Error deleting consultation', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro ao excluir consultation',
        ),
      );
    }
  }
}
