import 'package:result_dart/result_dart.dart';

import '../../../../core/command/command.dart';
import '../../domain/entities/clinical_record_entity.dart';
import '../../domain/repositories/i_clinical_record_repository.dart';

class ClinicalRecordViewmodel {
  final IClinicalRecordRepository _repository;

  ClinicalRecordViewmodel(this._repository) {
    savePatientClinicalRecordCommand = Command1(_repository.saveClinicalRecord);
    deletePatientClinicalRecordCommand =
        Command1(_repository.deleteClinicalRecord);

    patientClinicalRecordStream =
        CommandStream1(_repository.getPatientClinicalRecordsStream);
  }

  late final Command1<Unit, ClinicalRecordEntity>
      savePatientClinicalRecordCommand;
  late final Command1<Unit, String> deletePatientClinicalRecordCommand;
  late final CommandStream1<List<ClinicalRecordEntity>, String>
      patientClinicalRecordStream;
}
