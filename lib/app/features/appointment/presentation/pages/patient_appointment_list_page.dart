import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/widgets/result_handler.dart';
import 'package:flutter_therapy_evolution/app/features/appointment/domain/entities/appointment_entity.dart';
import 'package:flutter_therapy_evolution/app/features/patient/domain/entities/patient_entity.dart';

import '../../../../core/command/command_stream_listenable_builder.dart';
import '../../../../core/widgets/delete_dialog.dart';
import '../viewmodels/appointment_viewmodel.dart';

class PatientAppointmentListPage extends StatefulWidget {
  final PatientEntity patient;

  const PatientAppointmentListPage({
    super.key,
    required this.patient,
  });

  @override
  State<PatientAppointmentListPage> createState() =>
      _PatientAppointmentListPageState();
}

class _PatientAppointmentListPageState
    extends State<PatientAppointmentListPage> {
  final viewModel = Modular.get<AppointmentViewmodel>();

  PatientEntity get patient => widget.patient;

  @override
  void initState() {
    super.initState();

    viewModel.patientAppointmentsStreamCommand.execute(patient.id);
    viewModel.deleteAppointmentCommand.addListener(_onDeleteAppointment);
  }

  @override
  void dispose() {
    //List patient appointments
    viewModel.patientAppointmentsStreamCommand.dispose();
    //Delete appointment
    viewModel.deleteAppointmentCommand.removeListener(_onDeleteAppointment);
    super.dispose();
  }

  void _navigateToRegisterAppointment() {
    Modular.to.pushNamed(
      './register',
      arguments: {
        'patientEntity': patient,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendamentos de ${patient.name}'),
      ),
      body: CommandStreamListenableBuilder<List<AppointmentEntity>>(
        stream: viewModel.patientAppointmentsStreamCommand,
        emptyMessage:
            '${patient.name} não possui nenhum agendamento cadastrado',
        emptyIconData: Icons.calendar_month_rounded,
        builder: (context, value) {
          return _buildAppointmentList(value);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToRegisterAppointment,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAppointmentList(List<AppointmentEntity> appointments) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        final patientName = patient.name;

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.calendar_today, color: Colors.white),
            ),
            title: Text(
              patientName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Data: ${appointment.date}',
                ),
                Text(
                  'Horário: ${appointment.startTime} - ${appointment.endTime}',
                ),
                Text(
                  'Status: ${appointment.status}',
                ),
                if (appointment.notes != null &&
                    appointment.notes!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text('Obs: ${appointment.notes}'),
                ],
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => Modular.to.pushNamed(
                    './edit',
                    arguments: {
                      'appointmentEntity': appointment,
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDeleteAppointment(appointment),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onDeleteAppointment() {
    ResultHandler.showAlert(
      context: context,
      result: viewModel.deleteAppointmentCommand.result,
      successMessage: 'Agendamento excluído com sucesso!',
    );
  }

  void _confirmDeleteAppointment(AppointmentEntity appointment) {
    final patientName = viewModel.getPatientNameById(appointment.patientId);
    final appointmentDate = appointment.date;
    final appointmentTime = appointment.startTime;

    DeleteDialog.showDeleteConfirmation(
      context: context,
      title: 'Excluir Agendamento',
      entityName:
          'o agendamento de $patientName em $appointmentDate às $appointmentTime?',
      onConfirm: () {
        viewModel.deleteAppointmentCommand.execute(appointment.id);
      },
    );
  }
}
