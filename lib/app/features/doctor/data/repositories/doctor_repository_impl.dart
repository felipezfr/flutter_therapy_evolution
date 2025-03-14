import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/log/log_manager.dart';
import '../../../../core/session/logged_user.dart';
import '../../../../core/state_management/errors/repository_exception.dart';
import '../../../../core/typedefs/result_typedef.dart';
import '../../domain/entities/doctor_entity.dart';
import '../../domain/repositories/i_doctor_repository.dart';
import '../adapters/doctor_adapter.dart';

class DoctorRepositoryImpl implements IDoctorRepository {
  final FirebaseFirestore _firestore;

  DoctorRepositoryImpl(this._firestore);

  final String loggedUserId = LoggedUser.id;

  @override
  OutputStream<List<DoctorEntity>> getDoctorsStream() {
    try {
      return _firestore
          .collection('doctors')
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
            return DoctorAdapter.fromMap(data);
          }).toList();

          return Success(doctors);
        } catch (e, s) {
          Log.error('Error processing doctors snapshot',
              error: e, stackTrace: s);
          return Failure(
            RepositoryException(
              message: 'Erro ao processar dados dos doctors',
            ),
          );
        }
      });
    } catch (e, s) {
      Log.error('Error creating doctors stream', error: e, stackTrace: s);
      return Stream.value(
        Failure(
          RepositoryException(
            message: 'Erro ao criar stream de doctors',
          ),
        ),
      );
    }
  }

  @override
  Output<Unit> saveDoctor(DoctorEntity doctor) async {
    try {
      final saveMap = DoctorAdapter.toMap(doctor);
      saveMap.remove('id');

      // If id is empty, create a new document with auto-generated ID
      if (doctor.id.isEmpty) {
        saveMap['userId'] = LoggedUser.id;
        saveMap['isDeleted'] = false;
        saveMap['createdAt'] = DateTime.now();
        saveMap['updatedAt'] = DateTime.now();

        await _firestore.collection('doctors').add(saveMap);
        return Success(unit);
      }
      // update existing document
      else {
        saveMap['updatedAt'] = DateTime.now();
        await _firestore
            .collection('doctors')
            .doc(doctor.id)
            .update(saveMap);
        return Success(unit);
      }
    } catch (e, s) {
      Log.error('Error saving doctor', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro ao salvar doctor',
        ),
      );
    }
  }

  @override
  Output<Unit> deleteDoctor(String doctorId) async {
    try {
      final deleteMap = {
        'isDeleted': true,
        'deletedAt': DateTime.now(),
      };
      await _firestore.collection('doctors').doc(doctorId).update(deleteMap);
      return Success(unit);
    } catch (e, s) {
      Log.error('Error deleting doctor', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro ao excluir doctor',
        ),
      );
    }
  }
}
