import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/features/appointment/presentation/pages/patient_appointment_list_page.dart';

import '../../core/core_module.dart';
import '../patient/data/repositories/patient_repository_impl.dart';
import '../patient/data/repositories/i_patient_repository.dart';
import 'presentation/pages/appointment_list_page.dart';
import 'presentation/pages/appointment_register_page.dart';
import 'data/repositories/appointment_repository_impl.dart';
import 'data/repositories/i_appointment_repository.dart';
import 'presentation/viewmodels/appointment_viewmodel.dart';

class AppointmentModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i.addLazySingleton<IPatientRepository>(PatientRepositoryImpl.new);
    i.addLazySingleton<IAppointmentRepository>(AppointmentRepositoryImpl.new);
    i.addLazySingleton(AppointmentViewmodel.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const AppointmentListPage());
    r.child(
      '/patient',
      child: (context) => PatientAppointmentListPage(
        patient: r.args.data?['patientEntity'],
      ),
    );
    r.child(
      '/register',
      child: (context) => AppointmentRegisterPage(
        patient: r.args.data?['patientEntity'],
      ),
    );
    r.child(
      '/edit',
      child: (context) => AppointmentRegisterPage(
        appointment: r.args.data?['appointmentEntity'],
      ),
    );
  }
}
