import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/features/appointment/data/repositories/appointment_repository.dart';
import 'package:flutter_therapy_evolution/app/features/appointment/data/repositories/appointment_repository_impl.dart';
import 'package:flutter_therapy_evolution/app/features/clinical_record/presentation/pages/clinical_record_detail_page.dart';
import 'package:flutter_therapy_evolution/app/features/patient/data/repositories/patient_repository.dart';
import 'package:flutter_therapy_evolution/app/features/patient/data/repositories/patient_repository_impl.dart';

import '../../core/core_module.dart';
import 'data/repositories/clinical_record_repository_impl.dart';
import 'data/repositories/clinical_record_repository.dart';
import 'presentation/pages/patient_clinical_record_list_page.dart';
import 'presentation/viewmodels/clinical_record_viewmodel.dart';
import 'presentation/pages/patient_clinical_record_register.dart';

class ClinicalRecordModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i.addLazySingleton<IClinicalRecordRepository>(
        ClinicalRecordRepositoryImpl.new);
    i.addLazySingleton<IPatientRepository>(PatientRepositoryImpl.new);
    i.addLazySingleton<IAppointmentRepository>(AppointmentRepositoryImpl.new);
    i.addLazySingleton(ClinicalRecordViewmodel.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      '/patient/:patientId',
      child: (context) =>
          PatientClinicalRecordListPage(patientId: r.args.params['patientId']),
    );
    r.child(
      '/detail',
      child: (context) => PatientClinicalRecordDetailPage(
        clinicalRecordId: r.args.data['clinicalRecordId'],
        patientId: r.args.data['patientId'],
      ),
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
