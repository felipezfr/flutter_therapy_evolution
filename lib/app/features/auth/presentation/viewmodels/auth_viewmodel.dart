import 'package:flutter_therapy_evolution/app/core/services/session_service.dart';
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
  final SessionService _sessionService;

  AuthViewmodel(this._repository, this._sessionService) {
    loginCommand = Command1(_login);
    registerCommand = Command1(_register);
  }

  late final Command1<UserEntity, LoginParams> loginCommand;
  late final Command1<UserEntity, RegisterParams> registerCommand;

  Output<UserEntity> _login(LoginParams loginParams) {
    return _repository.login(loginParams).then(_saveUser);
  }

  Output<UserEntity> _register(RegisterParams registerParams) {
    return _repository.register(registerParams).then(_saveUser);
  }

  Output<UserEntity> _saveUser(Result<UserEntity, BaseException> result) async {
    return result.onSuccess((success) => _sessionService.saveUser(success));
  }
}
