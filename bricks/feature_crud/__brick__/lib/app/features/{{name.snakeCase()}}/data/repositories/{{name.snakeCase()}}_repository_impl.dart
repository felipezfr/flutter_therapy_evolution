import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/errors/repository_exception.dart';
import '../../../../core/log/log_manager.dart';
import '../../../../core/session/logged_user.dart';
import '../../../../core/typedefs/result_typedef.dart';
import '../../domain/entities/{{name.camelCase()}}_entity.dart';
import '{{name.camelCase()}}_repository.dart';

class {{name.pascalCase()}}RepositoryImpl implements I{{name.pascalCase()}}Repository {
  final FirebaseFirestore _firestore;

  {{name.pascalCase()}}RepositoryImpl(this._firestore);

  final String loggedUserId = LoggedUser.id;

  @override
  OutputStream<List<{{name.pascalCase()}}Entity>> get{{name.pascalCase()}}sStream() {
    try {
      return _firestore
          .collection('{{name.camelCase()}}s')
          .where('userId', isEqualTo: LoggedUser.id)
          .where('isDeleted', isEqualTo: false)
          .snapshots()
          .map((snapshot) {
        try {
          if (snapshot.docs.isEmpty) {
            return Success([]);
          }

          final {{name.camelCase()}}s = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return {{name.pascalCase()}}Entity.fromMap(data);
          }).toList();

          return Success({{name.camelCase()}}s);
        } catch (e, s) {
          Log.error('Error processing {{name.camelCase()}}s snapshot',
              error: e, stackTrace: s);
          return Failure(
            RepositoryException(
              message: 'Erro ao processar dados dos {{name.camelCase()}}s',
            ),
          );
        }
      });
    } catch (e, s) {
      Log.error('Error creating {{name.camelCase()}}s stream', error: e, stackTrace: s);
      return Stream.value(
        Failure(
          RepositoryException(
            message: 'Erro ao criar stream de {{name.camelCase()}}s',
          ),
        ),
      );
    }
  }

  @override
  Output<Unit> save{{name.pascalCase()}}({{name.pascalCase()}}Entity {{name.camelCase()}}) async {
    try {
      final saveMap = {{name.pascalCase()}}Entity.toMap({{name.camelCase()}});
      saveMap.remove('id');

      // If id is empty, create a new document with auto-generated ID
      if ({{name.camelCase()}}.id.isEmpty) {
        saveMap['userId'] = LoggedUser.id;
        saveMap['isDeleted'] = false;
        saveMap['createdAt'] = DateTime.now();
        saveMap['updatedAt'] = DateTime.now();

        await _firestore.collection('{{name.camelCase()}}s').add(saveMap);
        return Success(unit);
      }
      // update existing document
      else {
        saveMap['updatedAt'] = DateTime.now();
        await _firestore
            .collection('{{name.camelCase()}}s')
            .doc({{name.camelCase()}}.id)
            .update(saveMap);
        return Success(unit);
      }
    } catch (e, s) {
      Log.error('Error saving {{name.camelCase()}}', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro ao salvar {{name.camelCase()}}',
        ),
      );
    }
  }

  @override
  Output<Unit> delete{{name.pascalCase()}}(String {{name.camelCase()}}Id) async {
    try {
      final deleteMap = {
        'isDeleted': true,
        'deletedAt': DateTime.now(),
      };
      await _firestore.collection('{{name.camelCase()}}s').doc({{name.camelCase()}}Id).update(deleteMap);
      return Success(unit);
    } catch (e, s) {
      Log.error('Error deleting {{name.camelCase()}}', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro ao excluir {{name.camelCase()}}',
        ),
      );
    }
  }
}
