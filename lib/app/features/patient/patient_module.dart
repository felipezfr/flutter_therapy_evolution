import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/features/patient/presentation/patient_page.dart';
import 'package:flutter_therapy_evolution/app/features/patient/presentation/patient_viewmodel.dart';

class PatientModule extends Module {
  @override
  void binds(Injector i) {
    i.addLazySingleton(PatientViewmodel.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => PatientPage());
  }
}
