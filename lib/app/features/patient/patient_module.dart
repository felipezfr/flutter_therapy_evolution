import 'package:flutter_modular/flutter_modular.dart';

import '../../core/core_module.dart';
import 'data/repositories/patient_repository_impl.dart';
import 'data/repositories/i_patient_repository.dart';
import 'presentation/pages/patient_detail_page.dart';
import 'presentation/pages/patient_list_page.dart';
import 'presentation/pages/patient_register_page.dart';
import 'presentation/viewmodels/patient_viewmodel.dart';

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
    r.child('/', child: (context) => PatientListPage());
    r.child(
      '/detail',
      child: (context) => PatientDetailPage(
        patient: r.args.data['patientEntity'],
      ),
    );
    r.child('/register', child: (context) => PatientRegisterPage());
    r.child(
      '/edit',
      child: (context) =>
          PatientRegisterPage(patient: r.args.data['patientEntity']),
    );
  }
}
