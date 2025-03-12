import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/features/patient/patient_module.dart';

import 'features/auth/auth_module.dart';
import 'features/home/home_module.dart';
import 'features/splash/splash_module.dart';

class AppModule extends Module {
  @override
  void routes(r) {
    r.module('/', module: SplashModule());
    r.module('/auth', module: AuthModule());
    r.module('/home', module: HomeModule());
    r.module('/patient', module: PatientModule());
  }
}
