import 'package:result_dart/result_dart.dart';

import '../../../../core/typedefs/result_typedef.dart';
import '../entities/clinical_record_entity.dart';

abstract class IClinicalRecordRepository {
  OutputStream<List<ClinicalRecordEntity>> getClinicalRecordsStream();
  OutputStream<List<ClinicalRecordEntity>> getPatientClinicalRecordsStream(
      String patientId);
  Output<Unit> saveClinicalRecord(ClinicalRecordEntity record);
  Output<Unit> deleteClinicalRecord(String recordId);
}
