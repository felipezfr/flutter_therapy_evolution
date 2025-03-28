import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/session/session_usecase.dart';

import '../../core/core_module.dart';
import '../../core/repositories/user/user_repository.dart';
import '../../core/repositories/user/user_repository_impl.dart';
import 'presentation/splash_page.dart';

class SplashModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i.addLazySingleton<IUserRepository>(UserRepositoryImpl.new);
    i.addLazySingleton(SessionUsecase.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => SplashPage());
  }
}
