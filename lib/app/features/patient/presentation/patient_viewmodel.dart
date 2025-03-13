import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/command/command.dart';
import '../domain/entities/patient_entity.dart';
import '../domain/repositories/i_patient_repository.dart';

class PatientViewmodel {
  final IPatientRepository _repository;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  PatientViewmodel(this._repository) {
    savePatientCommand = Command1(_repository.savePatient);
    deletePatientCommand = Command1(_repository.deletePatient);
    patientsStreamCommand = CommandStream0(_repository.getPatientsStream);

    patientsStreamCommand.execute();
  }

  late final Command1<void, PatientEntity> savePatientCommand;
  late final Command1<void, String> deletePatientCommand;
  late final CommandStream0<List<PatientEntity>> patientsStreamCommand;

  String getCurrentUserId() {
    return _auth.currentUser?.uid ?? '';
  }
}
