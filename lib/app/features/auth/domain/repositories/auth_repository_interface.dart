import '../../../../core/command/result.dart';
import '../../presentation/models/login_params.dart';
import '../../presentation/models/register_params.dart';
import '../entities/user_entity.dart';

abstract interface class IAuthRepository {
  Future<Result<UserEntity>> login(LoginParams loginParams);
  Future<Result<UserEntity>> register(RegisterParams registerParams);
}
