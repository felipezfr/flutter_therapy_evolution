import 'package:result_dart/result_dart.dart';

import '../../../../core/typedefs/result_typedef.dart';
import '../../domain/entities/clinical_record_entity.dart';

abstract class IClinicalRecordRepository {
  OutputStream<List<ClinicalRecordEntity>> getAllClinicalRecordsStream();
  OutputStream<List<ClinicalRecordEntity>> getPatientClinicalRecordsStream(
      String patientId);
  OutputStream<ClinicalRecordEntity> getClinicalRecordStream(
      String clinicalRecordId);
  Output<Unit> saveClinicalRecord(ClinicalRecordEntity record);
  Output<Unit> deleteClinicalRecord(String recordId);
}
