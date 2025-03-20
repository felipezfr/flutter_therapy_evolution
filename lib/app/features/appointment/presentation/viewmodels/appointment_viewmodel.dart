import 'package:result_dart/result_dart.dart';

import '../../../../core/command/command.dart';
import '../../../../core/typedefs/result_typedef.dart';
import '../../../patient/domain/entities/patient_entity.dart';
import '../../../patient/data/repositories/patient_repository.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/enums/recurrence_type_enum.dart';
import '../../data/repositories/appointment_repository.dart';

class AppointmentViewmodel {
  final IAppointmentRepository _repository;
  final IPatientRepository _patientRepository;

  AppointmentViewmodel(this._repository, this._patientRepository) {
    //List
    allAppointmentsStreamCommand = CommandStream1(_getAllAppointmentsStream);
    appointmentsPatientStreamCommand =
        CommandStream1(_repository.getPatientAppointmentsStream);
    //Detail Appointment
    appointmentStreamCommand = CommandStream1(_repository.getAppointmentStream);
    //Create update delete
    saveAppointmentCommand = Command1(_repository.saveAppointment);
    saveRecurringAppointmentsCommand = Command1(_saveRecurringAppointments);
    deleteAppointmentCommand = Command1(_repository.deleteAppointment);
    deleteRecurringAppointmentsCommand =
        Command1(_repository.deleteRecurringAppointments);
    //Adicional data
    patientsStreamCommand =
        CommandStream0(_patientRepository.getPatientsStream);
    patientStreamCommand = CommandStream1(_patientRepository.getPatientStream);
    //Get adicional data
    patientsStreamCommand.execute();
  }

  //List
  late final CommandStream1<List<AppointmentEntity>, (int, int)>
      allAppointmentsStreamCommand;
  late final CommandStream1<List<AppointmentEntity>, String>
      appointmentsPatientStreamCommand;
  //Detail Appointment
  late final CommandStream1<AppointmentEntity, String> appointmentStreamCommand;

  //Create update delete
  late final Command1<Unit, AppointmentEntity> saveAppointmentCommand;
  late final Command1<Unit, (AppointmentEntity, RecurrenceType, int)>
      saveRecurringAppointmentsCommand;
  late final Command1<Unit, String> deleteAppointmentCommand;
  late final Command1<Unit, String> deleteRecurringAppointmentsCommand;
  //Adicional data
  late final CommandStream0<List<PatientEntity>> patientsStreamCommand;
  late final CommandStream1<PatientEntity, String> patientStreamCommand;

  OutputStream<List<AppointmentEntity>> _getAllAppointmentsStream(
      (int year, int month) date) {
    final (year, month) = (date.$1, date.$2);
    return _repository.getAllAppointmentsStream(year, month);
  }

  Output<Unit> _saveRecurringAppointments(
      (
        AppointmentEntity appointment,
        RecurrenceType recurrenceType,
        int count
      ) params) {
    return _repository.saveRecurringAppointments(
        params.$1, params.$2, params.$3);
  }

  String getPatientNameById(String patientId) {
    final patients = patientsStreamCommand.result?.getOrNull();

    if (patients == null || patients.isEmpty) {
      return 'Paciente não encontrado';
    }

    for (final patient in patients) {
      if (patient.id == patientId) {
        return patient.name;
      }
    }

    return 'Paciente não encontrado';
  }

  PatientEntity? getPatientById(String patientId) {
    final patients = patientsStreamCommand.result?.getOrNull();

    if (patients == null || patients.isEmpty) {
      return null;
    }

    for (final patient in patients) {
      if (patient.id == patientId) {
        return patient;
      }
    }

    return null;
  }
}
