import 'package:flutter_modular/flutter_modular.dart';

import '../../core/core_module.dart';
import 'data/repositories/patient_repository_impl.dart';
import 'domain/repositories/i_patient_repository.dart';
import 'presentation/patient_page.dart';
import 'presentation/patient_viewmodel.dart';

class PatientModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i.addLazySingleton<IPatientRepository>(PatientRepositoryImpl.new);
    i.addLazySingleton(PatientViewmodel.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => PatientPage());
  }
}
