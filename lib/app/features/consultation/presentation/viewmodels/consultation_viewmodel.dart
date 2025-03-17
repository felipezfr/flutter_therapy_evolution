import 'package:result_dart/result_dart.dart';

import '../../../../core/command/command.dart';
import '../../../patient/data/repositories/patient_repository.dart';
import '../../../patient/domain/entities/patient_entity.dart';
import '../../data/repositories/consultation_repository.dart';
import '../../domain/entities/consultation_entity.dart';

class ConsultationViewmodel {
  final IConsultationRepository _repository;
  final IPatientRepository _patientRepository;

  ConsultationViewmodel(this._repository, this._patientRepository) {
    consultationsStreamCommand =
        CommandStream0(_repository.getConsultationsStream);
    patientConsultationsStreamCommand =
        CommandStream1(_repository.getPatientConsultationsStream);
    consultationStreamCommand =
        CommandStream1(_repository.getConsultationStream);
    saveConsultationCommand = Command1(_repository.saveConsultation);
    deleteConsultationCommand = Command1(_repository.deleteConsultation);
    //Patients
    //Adicional data
    patientsStreamCommand =
        CommandStream0(_patientRepository.getPatientsStream);
    patientStreamCommand = CommandStream1(_patientRepository.getPatientStream);
  }

  late final CommandStream0<List<ConsultationEntity>>
      consultationsStreamCommand;
  late final CommandStream1<List<ConsultationEntity>, String>
      patientConsultationsStreamCommand;
  late final CommandStream1<ConsultationEntity, String>
      consultationStreamCommand;
  late final Command1<Unit, ConsultationEntity> saveConsultationCommand;
  late final Command1<Unit, String> deleteConsultationCommand;
  //Adicional data
  late final CommandStream0<List<PatientEntity>> patientsStreamCommand;
  late final CommandStream1<PatientEntity, String> patientStreamCommand;
}
