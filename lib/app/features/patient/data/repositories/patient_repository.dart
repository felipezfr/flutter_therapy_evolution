import 'package:result_dart/result_dart.dart';

import '../../../../core/typedefs/result_typedef.dart';
import '../../domain/entities/patient_entity.dart';

abstract class IPatientRepository {
  OutputStream<List<PatientEntity>> getPatientsStream();
  Output<Unit> savePatient(PatientEntity patient);
  Output<Unit> deletePatient(String patientId);
}
