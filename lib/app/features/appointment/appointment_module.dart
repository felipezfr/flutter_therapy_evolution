import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/services/session_service.dart';

import '../../core/core_module.dart';
import '../patient/data/repositories/patient_repository_impl.dart';
import '../patient/domain/repositories/i_patient_repository.dart';
import 'presentation/appointment_list_page.dart';
import 'presentation/appointment_schedule_page.dart';
import 'data/repositories/appointment_repository_impl.dart';
import 'domain/repositories/i_appointment_repository.dart';
import 'presentation/appointment_viewmodel.dart';

class AppointmentModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i.addLazySingleton<IPatientRepository>(PatientRepositoryImpl.new);
    i.addLazySingleton<IAppointmentRepository>(AppointmentRepositoryImpl.new);
    i.addLazySingleton(SessionService.new);
    i.addLazySingleton(AppointmentViewmodel.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const AppointmentListPage());
    r.child('/schedule', child: (context) => const AppointmentSchedulePage());
    r.child(
      '/register',
      child: (context) => AppointmentSchedulePage(),
    );
    r.child(
      '/edit',
      child: (context) => AppointmentSchedulePage(
        appointment: r.args.data['appointmentEntity'],
      ),
    );
  }
}
