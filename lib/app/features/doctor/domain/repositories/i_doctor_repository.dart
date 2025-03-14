import 'package:result_dart/result_dart.dart';

import '../../../../core/typedefs/result_typedef.dart';
import '../entities/doctor_entity.dart';

abstract class IDoctorRepository {
  OutputStream<List<DoctorEntity>> getDoctorsStream();
  Output<Unit> saveDoctor(DoctorEntity doctor);
  Output<Unit> deleteDoctor(String doctorId);
}
