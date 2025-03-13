import 'package:flutter_therapy_evolution/app/core/session/logged_user.dart';
import 'package:flutter_therapy_evolution/app/core/state_management/errors/base_exception.dart';
import 'package:flutter_therapy_evolution/app/core/typedefs/result_typedef.dart';
import 'package:flutter_therapy_evolution/app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_therapy_evolution/app/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/command/command.dart';
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

  Output<UserEntity> _login(LoginParams loginParams) {
    return _repository.login(loginParams).then(_setUser);
  }

  Output<UserEntity> _register(RegisterParams registerParams) {
    return _repository.register(registerParams).then(_setUser);
  }

  Output<UserEntity> _setUser(Result<UserEntity, BaseException> result) async {
    return result.onSuccess((success) => LoggedUser.setUserId = success.id);
  }
}
