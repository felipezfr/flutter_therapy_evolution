import '../../../core/command/command.dart';
import '../../patient/domain/entities/patient_entity.dart';
import '../../patient/domain/repositories/i_patient_repository.dart';
import '../domain/entities/appointment_entity.dart';
import '../domain/repositories/i_appointment_repository.dart';

class AppointmentViewmodel {
  final IAppointmentRepository _repository;
  final IPatientRepository _patientRepository;

  AppointmentViewmodel(this._repository, this._patientRepository) {
    saveAppointmentCommand = Command1(_repository.saveAppointment);
    deleteAppointmentCommand = Command1(_repository.deleteAppointment);
    appointmentsStreamCommand =
        CommandStream0(_repository.getAppointmentsStream);
    patientsStreamCommand =
        CommandStream0(_patientRepository.getPatientsStream);

    appointmentsStreamCommand.execute();
    patientsStreamCommand.execute();
  }

  late final Command1<void, AppointmentEntity> saveAppointmentCommand;
  late final Command1<void, String> deleteAppointmentCommand;
  late final CommandStream0<List<AppointmentEntity>> appointmentsStreamCommand;
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
