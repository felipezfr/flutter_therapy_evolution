import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/features/consultation/presentation/pages/patient_consultation_list_page.dart';

import '../../core/core_module.dart';
import '../patient/data/repositories/patient_repository.dart';
import '../patient/data/repositories/patient_repository_impl.dart';
import 'data/repositories/consultation_repository_impl.dart';
import 'data/repositories/consultation_repository.dart';
import 'presentation/pages/consultation_detail_page.dart';
import 'presentation/pages/consultation_list_page.dart';
import 'presentation/pages/consultation_register_page.dart';
import 'presentation/viewmodels/consultation_viewmodel.dart';

class ConsultationModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i.addLazySingleton<IPatientRepository>(PatientRepositoryImpl.new);
    i.addLazySingleton<IConsultationRepository>(ConsultationRepositoryImpl.new);
    i.addLazySingleton(ConsultationViewmodel.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => ConsultationListPage());
    r.child(
      '/patient/:patientId',
      child: (context) => PatientConsultationListPage(
        patientId: r.args.params['patientId'],
      ),
    );
    r.child(
      '/detail/:consultationId',
      child: (context) => ConsultationDetailPage(
        consultationId: r.args.params['consultationId'],
      ),
    );
    r.child(
      '/register',
      child: (context) => ConsultationRegisterPage(
        patient: r.args.data?['patientEntity'],
      ),
    );
    r.child(
      '/edit',
      child: (context) => ConsultationRegisterPage(
        consultation: r.args.data?['consultationEntity'],
      ),
    );
  }
}
