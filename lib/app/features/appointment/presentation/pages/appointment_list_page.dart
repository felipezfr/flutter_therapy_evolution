import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/widgets/delete_dialog.dart';
import 'package:flutter_therapy_evolution/app/features/appointment/domain/entities/appointment_entity.dart';
import '../../../../core/command/command_stream_listenable_builder.dart';
import '../../../../core/widgets/result_handler.dart';
import '../viewmodels/appointment_viewmodel.dart';

class AppointmentListPage extends StatefulWidget {
  const AppointmentListPage({
    super.key,
  });

  @override
  State<AppointmentListPage> createState() => _AppointmentListPageState();
}

class _AppointmentListPageState extends State<AppointmentListPage> {
  final viewModel = Modular.get<AppointmentViewmodel>();

  @override
  void initState() {
    super.initState();

    viewModel.allAppointmentsStreamCommand.execute();
    viewModel.deleteAppointmentCommand.addListener(_listener);
  }

  @override
  void dispose() {
    //List All appointments
    viewModel.allAppointmentsStreamCommand.dispose();
    //Delete
    viewModel.deleteAppointmentCommand.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos agendamentos'),
      ),
      body: CommandStreamListenableBuilder<List<AppointmentEntity>>(
        stream: viewModel.allAppointmentsStreamCommand,
        emptyMessage: 'Voce não possui nenhum agendamento cadastrado',
        emptyIconData: Icons.calendar_month_rounded,
        builder: (context, value) {
          return _buildAppointmentList(value);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToRegisterPage,
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
        final patientName = viewModel.getPatientNameById(appointment.patientId);

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            onTap: () => _navigateToDetailPage(appointment),
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
                  onPressed: () => _navigateToEditPage(appointment),
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

  void _navigateToEditPage(AppointmentEntity appointment) {
    Modular.to.pushNamed('./edit', arguments: {
      'appointmentEntity': appointment,
    });
  }

  void _navigateToDetailPage(AppointmentEntity appointment) {
    Modular.to.pushNamed('./detail/${appointment.id}');
  }

  void _navigateToRegisterPage() {
    Modular.to.pushNamed('./register');
  }

  void _listener() {
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
      title: 'Excluir Paciente',
      entityName:
          'o agendamento de $patientName em $appointmentDate às $appointmentTime?',
      onConfirm: () {
        viewModel.deleteAppointmentCommand.execute(appointment.id);
      },
    );
  }
}
