import 'package:result_dart/result_dart.dart';

import '../../../../core/state_management/errors/base_exception.dart';
import '../../../../core/typedefs/result_typedef.dart';
import '../entities/medical_test_entity.dart';

abstract class IMedicalTestRepository {
  Stream<Result<List<MedicalTestEntity>, BaseException>>
      getMedicalTestsStream();
  Stream<Result<List<MedicalTestEntity>, BaseException>>
      getPatientMedicalTestsStream(String patientId);
  Output<MedicalTestEntity> getMedicalTest(String testId);
  Output<MedicalTestEntity> saveMedicalTest(MedicalTestEntity test);
  Output<Unit> deleteMedicalTest(String testId);
}
