import 'package:result_dart/result_dart.dart';

import '../../../../core/command/command.dart';
import '../../../patient/domain/entities/patient_entity.dart';
import '../../../patient/data/repositories/patient_repository.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../data/repositories/appointment_repository.dart';

class AppointmentViewmodel {
  final IAppointmentRepository _repository;
  final IPatientRepository _patientRepository;

  AppointmentViewmodel(this._repository, this._patientRepository) {
    //List
    allAppointmentsStreamCommand =
        CommandStream0(_repository.getAllAppointmentsStream);
    patientsStreamCommand =
        CommandStream0(_patientRepository.getPatientsStream);
    //Detail Appointment
    appointmentStreamCommand = CommandStream1(_repository.getAppointmentStream);
    //Create update delete
    saveAppointmentCommand = Command1(_repository.saveAppointment);
    deleteAppointmentCommand = Command1(_repository.deleteAppointment);
    //Adicional data
    patientAppointmentsStreamCommand =
        CommandStream1(_repository.getPatientAppointmentsStream);
    //Get adicional data
    patientsStreamCommand.execute();
  }

  //List
  late final CommandStream0<List<AppointmentEntity>>
      allAppointmentsStreamCommand;
  late final CommandStream1<List<AppointmentEntity>, String>
      patientAppointmentsStreamCommand;
  //Detail Appointment
  late final CommandStream1<AppointmentEntity, String> appointmentStreamCommand;

  //Create update delete
  late final Command1<Unit, AppointmentEntity> saveAppointmentCommand;
  late final Command1<Unit, String> deleteAppointmentCommand;
  //Adicional data
  late final CommandStream0<List<PatientEntity>> patientsStreamCommand;

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
}
