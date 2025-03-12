import 'package:flutter_modular/flutter_modular.dart';

import '../../core/core_module.dart';
import '../../core/services/session_service.dart';
import 'presentation/splash_page.dart';

class SplashModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];
  @override
  void binds(Injector i) {
    i.addLazySingleton(SessionService.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => SplashPage());
  }
}
