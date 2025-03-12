import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/log/log_manager.dart';
import '../../../../core/state_management/errors/repository_exception.dart';
import '../../../../core/typedefs/result_typedef.dart';
import '../../domain/entities/{{name.snakeCase()}}_entity.dart';
import '../../domain/repositories/i_{{name.snakeCase()}}_repository.dart';
import '../adapters/{{name.snakeCase()}}_adapter.dart';

class {{name.pascalCase()}}RepositoryImpl implements I{{name.pascalCase()}}Repository {

  final FirebaseFirestore _firestore;

  {{name.pascalCase()}}RepositoryImpl(this._firestore);

  @override
  Output<{{name.pascalCase()}}Entity> fetchData() async {
    try {
      final doc = await _firestore.collection('collection').doc('doc').get();

      if (!doc.exists) {
        return Failure(RepositoryException(
          message: 'Dados não encontrados',
        ));
      }

      final userData = doc.data()!;

      return Success({{name.pascalCase()}}Adapter.fromMap(userData));
    } catch (e, s) {
      Log.error('Error {{name.pascalCase()}}', error: e, stackTrace: s);

      return Failure(
        RepositoryException(
          message: 'Erro inesperado',
        ),
      );
    }

  }
}