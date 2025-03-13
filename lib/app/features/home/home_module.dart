import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/repositories/user/i_user_repository.dart';
import 'package:flutter_therapy_evolution/app/core/repositories/user/user_repository_impl.dart';
import 'package:flutter_therapy_evolution/app/core/session/logged_user_usecase.dart';
import 'package:flutter_therapy_evolution/app/core/session/session_service.dart';
import 'package:flutter_therapy_evolution/app/features/home/presentation/profile_page.dart';

import '../../core/core_module.dart';
import 'data/repositories/home_repository_impl.dart';
import 'domain/repositories/i_home_repository.dart';
import 'presentation/home_page.dart';
import 'presentation/home_viewmodel.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i.addLazySingleton<IHomeRepository>(HomeRepositoryImpl.new);
    i.addLazySingleton<IUserRepository>(UserRepositoryImpl.new);
    i.addLazySingleton(LoggedUserUsecase.new);
    i.addLazySingleton(SessionService.new);
    i.addLazySingleton(HomeViewmodel.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => HomePage());
    r.child('/profile', child: (context) => ProfilePage());
  }
}
