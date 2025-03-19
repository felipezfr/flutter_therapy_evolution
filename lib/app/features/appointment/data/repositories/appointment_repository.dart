import 'package:result_dart/result_dart.dart';

import '../../../../core/typedefs/result_typedef.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/enums/recurrence_type_enum.dart';

abstract class IAppointmentRepository {
  OutputStream<List<AppointmentEntity>> getAllAppointmentsStream(
      int year, int month);
  OutputStream<List<AppointmentEntity>> getPatientAppointmentsStream(
      String patientId);
  OutputStream<AppointmentEntity> getAppointmentStream(String appointmentId);

  Output<Unit> saveAppointment(AppointmentEntity appointment);
  Output<Unit> saveRecurringAppointments(
      AppointmentEntity appointment, RecurrenceType recurrenceType, int count);
  Output<Unit> deleteAppointment(String appointmentId);
  Output<Unit> deleteRecurringAppointments(String recurringGroupId);
}
