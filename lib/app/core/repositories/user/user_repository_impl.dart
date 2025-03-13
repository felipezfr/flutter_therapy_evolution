import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_therapy_evolution/app/core/repositories/user/i_user_repository.dart';
import 'package:flutter_therapy_evolution/app/core/state_management/errors/base_exception.dart';
import 'package:flutter_therapy_evolution/app/core/typedefs/result_typedef.dart';
import 'package:flutter_therapy_evolution/app/features/auth/domain/dtos/user_adapter.dart';
import 'package:flutter_therapy_evolution/app/features/auth/domain/entities/user_entity.dart';
import 'package:result_dart/result_dart.dart';

import '../../log/log_manager.dart';
import '../../state_management/errors/repository_exception.dart';

class UserRepositoryImpl implements IUserRepository {
  final FirebaseFirestore _firestore;

  UserRepositoryImpl(this._firestore);

  @override
  Stream<Result<UserEntity, BaseException>> getUserStream(String userId) {
    try {
      return _firestore
          .collection('users')
          .doc(userId)
          .snapshots()
          .map((snapshot) {
        try {
          if (!snapshot.exists) {
            return Failure(
              RepositoryException(
                message: 'Usuário não encontrado',
              ),
            );
          }

          final data = snapshot.data();
          data!['id'] = snapshot.id;
          final userEntity = UserAdapter.fromMap(data);

          return Success(userEntity);
        } catch (e, s) {
          Log.error('Error processing user snapshot', error: e, stackTrace: s);
          return Failure(
            RepositoryException(
              message: 'Erro ao processar dados do usuário',
            ),
          );
        }
      });
    } catch (e, s) {
      Log.error('Error creating user stream', error: e, stackTrace: s);
      return Stream.value(
        Failure(
          RepositoryException(
            message: 'Erro ao criar stream de usuário',
          ),
        ),
      );
    }
  }

  @override
  Output<Unit> saveLastAccess(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'lastAccess': DateTime.now(),
      });

      return Success(unit);
    } catch (e, s) {
      Log.error('Error saveLastAccess', error: e, stackTrace: s);
      return Failure(
        RepositoryException(
          message: 'Erro inesperado',
        ),
      );
    }
  }
}
