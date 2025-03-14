import 'package:result_dart/result_dart.dart';

import '../../../../core/command/command.dart';
import '../../domain/entities/patient_entity.dart';
import '../../data/repositories/patient_repository.dart';

class PatientViewmodel {
  final IPatientRepository _repository;

  PatientViewmodel(this._repository) {
    patientsStreamCommand = CommandStream0(_repository.getPatientsStream);
    savePatientCommand = Command1(_repository.savePatient);
    deletePatientCommand = Command1(_repository.deletePatient);

    patientsStreamCommand.execute();
  }

  late final CommandStream0<List<PatientEntity>> patientsStreamCommand;
  late final Command1<Unit, PatientEntity> savePatientCommand;
  late final Command1<Unit, String> deletePatientCommand;
}
