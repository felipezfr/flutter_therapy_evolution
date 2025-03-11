import 'dart:developer';

import 'package:result_dart/result_dart.dart';

import '../../../../../core/extensions/lucid_validator_extensions.dart';
import '../../../../../core/services/session_service.dart';
import '../../../../../core/typedefs/types.dart';
import '../../../../../core/usecase/usecase_interface.dart';
import '../dtos/login_params.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository_interface.dart';
import '../validators/login_params_validator.dart';

class LoginUsecase implements UseCase<AuthEntity, LoginParams> {
  final IAuthRepository _authRepository;
  // final SessionService _sessionService;

  LoginUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Output<AuthEntity> call(LoginParams params) async {
    final validator = LoginParamsValidator();

    final result = await validator

        /// valida o loginParams
        .validateResult(params)

        /// converte em um async Result: Future<Result<...>>
        .toAsyncResult()

        /// executa o respository
        .flatMap(_authRepository.login);

    final authEntity = result.getOrNull();

    if (result.isSuccess() && authEntity != null) {
      log('Token: ${authEntity.accessToken}');
      // _sessionService.saveToken(authEntity.accessToken);
      // _sessionService.saveUser(authEntity.user);
    }

    return result;
  }
}
