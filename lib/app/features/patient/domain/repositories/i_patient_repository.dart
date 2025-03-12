import '../../../../core/typedefs/result_typedef.dart';
import '../entities/patient_entity.dart';

abstract class IPatientRepository {
  Output<PatientEntity> fetchData();
}