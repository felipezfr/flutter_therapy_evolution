import '../../../../../core/typedefs/types.dart';
import '../dtos/login_params.dart';
import '../dtos/register_params.dart';
import '../entities/auth_entity.dart';
import '../entities/user_entity.dart';

abstract interface class IAuthRepository {
  Output<AuthEntity> login(LoginParams params);
  Output<UserEntity> signUp(RegisterParams params);
}
