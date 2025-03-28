import 'package:flutter_modular/flutter_modular.dart';

import 'package:flutter_therapy_evolution/app/features/home/presentation/profile_page.dart';

import '../../core/core_module.dart';
import 'data/repositories/home_repository_impl.dart';
import 'data/repositories/home_repository.dart';
import 'presentation/home_page.dart';
import 'presentation/home_viewmodel.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i.addLazySingleton<IHomeRepository>(HomeRepositoryImpl.new);

    i.addLazySingleton(HomeViewmodel.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => HomePage());
    r.child('/profile', child: (context) => ProfilePage());
  }
}
