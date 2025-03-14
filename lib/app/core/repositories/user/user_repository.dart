import 'package:flutter_therapy_evolution/app/core/errors/base_exception.dart';
import 'package:flutter_therapy_evolution/app/core/typedefs/result_typedef.dart';
import 'package:flutter_therapy_evolution/app/core/entities/user_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract class IUserRepository {
  Stream<Result<UserEntity, BaseException>> getUserStream(String userId);
  Output<Unit> saveLastAccess(String userId);
  Output<UserEntity> getUserById(String userId);
}
