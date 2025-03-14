import 'package:flutter/foundation.dart';
import 'package:flutter_therapy_evolution/app/core/typedefs/result_typedef.dart';
import 'package:result_dart/result_dart.dart';

import '../../presentation/models/login_params.dart';
import '../../presentation/models/register_params.dart';

abstract class IAuthRepository extends ChangeNotifier {
  Future<bool> get isAuthenticated;
  Future<String> get userLoggedId;

  Output<Unit> login(LoginParams loginParams);
  Output<Unit> register(RegisterParams registerParams);
  Output<Unit> saveLastLoginDate(String userId);
  Output<void> logout();
}
