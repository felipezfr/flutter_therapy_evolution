import 'package:result_dart/result_dart.dart';

import '../../../../core/state_management/errors/base_exception.dart';
import '../../../../core/typedefs/result_typedef.dart';
import '../entities/clinical_record_entity.dart';

abstract class IClinicalRecordRepository {
  Stream<Result<List<ClinicalRecordEntity>, BaseException>>
      getClinicalRecordsStream();
  Stream<Result<List<ClinicalRecordEntity>, BaseException>>
      getPatientClinicalRecordsStream(String patientId);
  Output<ClinicalRecordEntity> getClinicalRecord(String recordId);
  Output<void> saveClinicalRecord(ClinicalRecordEntity record);
  Output<void> deleteClinicalRecord(String recordId);
}
