import '../../../core/command/command.dart';
import '../../../core/typedefs/result_typedef.dart';
import '../domain/entities/patient_entity.dart';
import '../domain/repositories/i_patient_repository.dart';

class PatientViewmodel{

  final IPatientRepository _repository;

  PatientViewmodel(this._repository) {
    defaultCommand = Command0(_getPatient);
  }

  late final Command0<PatientEntity> defaultCommand;

  Output<PatientEntity> _getPatient() {
    return _repository.fetchData();
  }

}