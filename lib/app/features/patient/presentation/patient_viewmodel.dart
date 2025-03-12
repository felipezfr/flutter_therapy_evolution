import '../../../core/command/command.dart';
import '../domain/entities/patient_entity.dart';
import '../domain/repositories/i_patient_repository.dart';

class PatientViewmodel {
  final IPatientRepository _repository;

  PatientViewmodel(this._repository) {
    savePatientCommand = Command1(_repository.savePatient);
    patientsStreamCommand = CommandStream0(_repository.getPatientsStream);
    deletePatientCommand = Command1(_repository.deletePatient);
  }

  late final Command1<void, PatientEntity> savePatientCommand;
  late final Command1<void, String> deletePatientCommand;
  late final CommandStream0<List<PatientEntity>> patientsStreamCommand;
}
