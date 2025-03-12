import 'package:result_dart/result_dart.dart';

import '../../../../core/state_management/errors/base_exception.dart';
import '../../../../core/typedefs/result_typedef.dart';
import '../entities/appointment_entity.dart';

abstract class IAppointmentRepository {
  Stream<Result<List<AppointmentEntity>, BaseException>>
      getAppointmentsStream();
  Output<AppointmentEntity> saveAppointment(AppointmentEntity appointment);
  Output<Unit> deleteAppointment(String appointmentId);
}
