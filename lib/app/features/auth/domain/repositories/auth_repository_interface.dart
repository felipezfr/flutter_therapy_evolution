import 'package:flutter_therapy_evolution/app/core/typedefs/result_typedef.dart';

import '../../presentation/models/login_params.dart';
import '../../presentation/models/register_params.dart';
import '../entities/user_entity.dart';

abstract interface class IAuthRepository {
  Output<UserEntity> login(LoginParams loginParams);
  Output<UserEntity> getUserById(String userId);
  Output<UserEntity> register(RegisterParams registerParams);
}
