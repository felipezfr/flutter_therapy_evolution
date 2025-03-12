import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/core_module.dart';
import 'package:flutter_therapy_evolution/app/core/services/session_service.dart';
import 'package:flutter_therapy_evolution/app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_therapy_evolution/app/features/auth/presentation/pages/auth_base_page.dart';
import 'package:flutter_therapy_evolution/app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_therapy_evolution/app/features/auth/presentation/pages/register_page.dart';
import 'package:flutter_therapy_evolution/app/features/auth/presentation/viewmodels/auth_viewmodel.dart';

import 'domain/repositories/auth_repository_interface.dart';

class AuthModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i.addLazySingleton<IAuthRepository>(AuthRepositoryImpl.new);
    i.addLazySingleton(SessionService.new);
    i.addLazySingleton(AuthViewmodel.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => AuthBasePage());
    r.child('/login', child: (context) => LoginPage());
    r.child('/register', child: (context) => RegisterPage());
  }
}
