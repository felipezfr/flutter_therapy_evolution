import 'package:flutter_modular/flutter_modular.dart';

import '../../core/core_module.dart';
import 'data/repositories/doctor_repository_impl.dart';
import 'domain/repositories/i_doctor_repository.dart';
import 'presentation/pages/doctor_detail_page.dart';
import 'presentation/pages/doctor_list_page.dart';
import 'presentation/pages/doctor_register_page.dart';
import 'presentation/viewmodels/doctor_viewmodel.dart';

class DoctorModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i.addLazySingleton<IDoctorRepository>(DoctorRepositoryImpl.new);
    i.addLazySingleton(DoctorViewmodel.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => DoctorListPage());
    r.child(
      '/detail',
      child: (context) => DoctorDetailPage(
        doctor: r.args.data['doctorEntity'],
      ),
    );
    r.child('/register', child: (context) => DoctorRegisterPage());
    r.child(
      '/edit',
      child: (context) =>
          DoctorRegisterPage(doctor: r.args.data['doctorEntity']),
    );
  }
}
