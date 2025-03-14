import 'package:flutter_therapy_evolution/app/core/typedefs/result_typedef.dart';
import 'package:flutter_therapy_evolution/app/features/auth/data/repositories/auth_repository.dart';
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

  late final Command1<Unit, LoginParams> loginCommand;
  late final Command1<Unit, RegisterParams> registerCommand;

  Output<Unit> _login(LoginParams loginParams) {
    return _repository.login(loginParams);
    // return _repository.login(loginParams).then(_setUser);
  }

  Output<Unit> _register(RegisterParams registerParams) {
    return _repository.register(registerParams);
  }

  // Output<UserEntity> _setUser(Result<Unit, BaseException> result) async {
  //   return result.onSuccess((success) => LoggedUser.setUserId = success.id);
  // }
}
