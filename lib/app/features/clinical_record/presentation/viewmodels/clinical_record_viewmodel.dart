import 'package:result_dart/result_dart.dart';

import '../../../../core/command/command.dart';
import '../../domain/entities/clinical_record_entity.dart';
import '../../data/repositories/clinical_record_repository.dart';

class ClinicalRecordViewmodel {
  final IClinicalRecordRepository _repository;

  ClinicalRecordViewmodel(this._repository) {
    savePatientClinicalRecordCommand = Command1(_repository.saveClinicalRecord);
    deleteClinicalRecordCommand = Command1(_repository.deleteClinicalRecord);

    clinicalRecordStream =
        CommandStream1(_repository.getPatientClinicalRecordsStream);
  }

  late final Command1<Unit, ClinicalRecordEntity>
      savePatientClinicalRecordCommand;
  late final Command1<Unit, String> deleteClinicalRecordCommand;
  late final CommandStream1<List<ClinicalRecordEntity>, String>
      clinicalRecordStream;
}
