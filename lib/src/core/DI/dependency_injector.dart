import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../../app/features/auth/data/repositories/auth_repository_impl.dart';
import '../../app/features/auth/domain/repositories/auth_repository_interface.dart';
import '../../app/features/auth/domain/usecases/login_usecase.dart';
import '../../app/features/auth/domain/usecases/logout_usecase.dart';
import '../../app/features/auth/domain/usecases/sign_up_usecase.dart';
import '../../app/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../app/features/home/domain/repositories/pet_repository_interface.dart';
import '../../app/features/home/domain/usecases/get_pet_usecase.dart';
import '../../app/features/home/presentation/viewmodels/home_viewmodel.dart';

import '../services/session_service.dart';

final injector = GetIt.instance;

void setupDependencyInjector() {
  // Firebase instances
  injector.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  injector.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);

  injector.registerLazySingleton<SessionService>;

  injector.registerFactory<IAuthRepository>(
    () => AuthRepositoryImpl(
      injector<FirebaseAuth>(),
      injector<FirebaseFirestore>(),
    ),
  );

  injector.registerLazySingleton(
    () => AuthViewmodel(
      signUpUsecase: SignUpUsecase(
        authRepository: injector<IAuthRepository>(),
      ),
      loginUsecase: LoginUsecase(
        authRepository: injector<IAuthRepository>(),
      ),
    ),
  );
  injector.registerLazySingleton(
    () => HomeViewmodel(
      getPetUsecase: GetPetUsecase(
        petRepository: injector<IPetRepository>(),
      ),
      logoutUsecase: LogoutUsecase(
          // sessionService: injector<SessionService>(),
          ),
    ),
  );
}
