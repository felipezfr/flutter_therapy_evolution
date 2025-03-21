import 'package:flutter_therapy_evolution/app/features/appointment/data/repositories/appointment_repository.dart';
import 'package:flutter_therapy_evolution/app/features/appointment/domain/entities/appointment_entity.dart';
import 'package:flutter_therapy_evolution/app/features/patient/data/repositories/patient_repository.dart';
import 'package:flutter_therapy_evolution/app/features/patient/domain/entities/patient_entity.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/command/command.dart';
import '../../domain/entities/clinical_record_entity.dart';
import '../../data/repositories/clinical_record_repository.dart';

class ClinicalRecordViewmodel {
  final IClinicalRecordRepository _repository;
  final IPatientRepository _patientRepository;
  final IAppointmentRepository _appointmentRepository;

  ClinicalRecordViewmodel(
      this._repository, this._patientRepository, this._appointmentRepository) {
    clinicalRecordsPatientStream =
        CommandStream1(_repository.getPatientClinicalRecordsStream);
    clinicalRecordStream = CommandStream1(_repository.getClinicalRecordStream);
    savePatientClinicalRecordCommand = Command1(_repository.saveClinicalRecord);
    deleteClinicalRecordCommand = Command1(_repository.deleteClinicalRecord);
    //Patient
    patientStreamCommand = CommandStream1(_patientRepository.getPatientStream);
    //Patient appointments
    appointmentsPatientStream =
        CommandStream1(_appointmentRepository.getPatientAppointmentsStream);
  }

  late final CommandStream1<List<ClinicalRecordEntity>, String>
      clinicalRecordsPatientStream;
  late final CommandStream1<ClinicalRecordEntity, String> clinicalRecordStream;
  late final CommandStream1<PatientEntity, String> patientStreamCommand;
  late final Command1<Unit, ClinicalRecordEntity>
      savePatientClinicalRecordCommand;
  late final Command1<Unit, String> deleteClinicalRecordCommand;
  //Patient Appointments
  late final CommandStream1<List<AppointmentEntity>, String>
      appointmentsPatientStream;
}
