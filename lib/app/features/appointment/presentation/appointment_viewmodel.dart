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
  }

  late final Command1<AppointmentEntity, AppointmentEntity>
      saveAppointmentCommand;
  late final Command1<void, String> deleteAppointmentCommand;
  late final CommandStream0<List<AppointmentEntity>> appointmentsStreamCommand;
  late final CommandStream0<List<PatientEntity>> patientsStreamCommand;

  String getPatientNameById(String patientId) {
    final patient = patientsStreamCommand.result?.getOrNull()?.firstWhere(
          (element) => element.id == patientId,
        );
    return patient?.name ?? 'Paciente não encontrado';
  }
}
