import 'package:result_dart/result_dart.dart';

import '../../../../core/state_management/errors/base_exception.dart';
import '../../../../core/typedefs/result_typedef.dart';
import '../entities/patient_entity.dart';

abstract class IPatientRepository {
  Stream<Result<List<PatientEntity>, BaseException>> getPatientsStream();
  Output<PatientEntity> getPatient(String patientId);
  Output<PatientEntity> savePatient(PatientEntity patient);
  Output<Unit> deletePatient(String patientId);
  Output<Unit> updatePatientStatus(String patientId, String status);
}
