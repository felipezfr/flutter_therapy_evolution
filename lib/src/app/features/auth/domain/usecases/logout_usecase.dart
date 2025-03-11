import 'dart:developer';

import 'package:result_dart/result_dart.dart';

import '../../../../../core/errors/default_exception.dart';
import '../../../../../core/services/session_service.dart';
import '../../../../../core/typedefs/types.dart';
import '../../../../../core/usecase/usecase_interface.dart';

class LogoutUsecase implements UseCase<Unit, Object?> {
  LogoutUsecase();

  @override
  Output<Unit> call([_]) async {
    final removed = await Future.wait([]);

    log('Remove Token and User');
    return const Success(unit);
    // return const Failure(
    //     DefaultException(message: 'Not remove token and user'));
  }
}
