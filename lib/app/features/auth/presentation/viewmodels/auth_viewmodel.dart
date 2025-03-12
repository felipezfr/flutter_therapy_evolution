import 'package:flutter_therapy_evolution/app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_therapy_evolution/app/features/auth/domain/repositories/auth_repository_interface.dart';

import '../../../../core/command/command.dart';
import '../../../../core/command/result.dart';
import '../models/login_params.dart';
import '../models/register_params.dart';

class AuthViewmodel {
  final IAuthRepository _repository;

  AuthViewmodel(this._repository) {
    loginCommand = Command1(_login);
    registerCommand = Command1(_register);
  }

  late final Command1<UserEntity, LoginParams> loginCommand;
  late final Command1<UserEntity, RegisterParams> registerCommand;

  Future<Result<UserEntity>> _login(LoginParams loginParams) {
    return _repository.login(loginParams);
  }

  Future<Result<UserEntity>> _register(RegisterParams registerParams) {
    return _repository.register(registerParams);
  }
}
