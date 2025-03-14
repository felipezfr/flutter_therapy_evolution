import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/log/log_manager.dart';
import '../../../../core/errors/repository_exception.dart';
import '../../../../core/typedefs/result_typedef.dart';
import '../../domain/entities/home_entity.dart';
import 'home_repository.dart';

class HomeRepositoryImpl implements IHomeRepository {
  final FirebaseFirestore _firestore;

  HomeRepositoryImpl(this._firestore);

  @override
  Output<HomeEntity> fetchData() async {
    try {
      final doc = await _firestore.collection('collection').doc('doc').get();

      if (!doc.exists) {
        return Failure(RepositoryException(
          message: 'Dados não encontrados',
        ));
      }

      final userData = doc.data()!;

      return Success(HomeEntity.fromMap(userData));
    } catch (e, s) {
      Log.error('Error Home', error: e, stackTrace: s);

      return Failure(
        RepositoryException(
          message: 'Erro inesperado',
        ),
      );
    }
  }
}
