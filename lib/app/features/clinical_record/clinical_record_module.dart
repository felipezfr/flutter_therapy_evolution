import 'package:flutter_modular/flutter_modular.dart';

import '../../core/core_module.dart';
import 'data/repositories/clinical_record_repository_impl.dart';
import 'domain/repositories/i_clinical_record_repository.dart';
import 'presentation/pages/patient_clinical_record_page.dart';
import 'presentation/viewmodels/clinical_record_viewmodel.dart';
import 'presentation/pages/patient_clinical_record_register.dart';

class ClinicalRecordModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i.addLazySingleton<IClinicalRecordRepository>(
        ClinicalRecordRepositoryImpl.new);
    i.addLazySingleton(ClinicalRecordViewmodel.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      '/patient',
      child: (context) =>
          PatientClinicalRecordPage(patient: r.args.data['patientEntity']),
    );

    r.child(
      '/register',
      child: (context) => PatientClinicalRecordRegisterPage(
          patient: r.args.data['patientEntity']),
    );
    r.child(
      '/edit',
      child: (context) => PatientClinicalRecordRegisterPage(
        patient: r.args.data['patientEntity'],
        clinicalRecord: r.args.data['clinicalRecordEntity'],
      ),
    );
  }
}
