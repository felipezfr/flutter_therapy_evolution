import 'package:result_dart/result_dart.dart';

import '../../../../core/typedefs/result_typedef.dart';
import '../entities/appointment_entity.dart';

abstract class IAppointmentRepository {
  OutputStream<List<AppointmentEntity>> getAllAppointmentsStream();
  OutputStream<List<AppointmentEntity>> getPatientAppointmentsStream(
      String patientId);
  Output<Unit> saveAppointment(AppointmentEntity appointment);
  Output<Unit> deleteAppointment(String appointmentId);
}
