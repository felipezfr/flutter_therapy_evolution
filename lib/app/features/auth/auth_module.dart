import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_therapy_evolution/app/features/auth/presentation/pages/auth_base_page.dart';
import 'package:flutter_therapy_evolution/app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_therapy_evolution/app/features/auth/presentation/pages/register_page.dart';
import 'package:flutter_therapy_evolution/app/features/auth/presentation/viewmodels/auth_viewmodel.dart';

import 'domain/repositories/auth_repository_interface.dart';

class AuthModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(FirebaseAuth.instance);
    i.addInstance(FirebaseFirestore.instance);
    i.addLazySingleton<IAuthRepository>(AuthRepositoryImpl.new);
    i.addLazySingleton(AuthViewmodel.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => AuthBasePage());
    r.child('/login', child: (context) => LoginPage());
    r.child('/register', child: (context) => RegisterPage());
  }
}
