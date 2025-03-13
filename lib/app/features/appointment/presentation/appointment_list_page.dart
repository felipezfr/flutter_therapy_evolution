import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/features/appointment/domain/entities/appointment_entity.dart';

import '../../../core/alert/alerts.dart';
import '../../patient/presentation/widgets/empty_state_widget.dart';
import '../../patient/presentation/widgets/error_state_widget.dart';
import 'appointment_viewmodel.dart';

class AppointmentListPage extends StatefulWidget {
  const AppointmentListPage({super.key});

  @override
  State<AppointmentListPage> createState() => _AppointmentListPageState();
}

class _AppointmentListPageState extends State<AppointmentListPage> {
  final viewModel = Modular.get<AppointmentViewmodel>();

  @override
  void initState() {
    super.initState();
    viewModel.deleteAppointmentCommand.addListener(_onDeleteAppointment);
  }

  @override
  void dispose() {
    viewModel.appointmentsStreamCommand.dispose();
    viewModel.patientsStreamCommand.dispose();
    viewModel.deleteAppointmentCommand.removeListener(_onDeleteAppointment);
    super.dispose();
  }

  void _onDeleteAppointment() {
    viewModel.deleteAppointmentCommand.result?.fold(
      (success) {
        Alerts.showSuccess(context, 'Agendamento excluído com sucesso!');
      },
      (failure) {
        Alerts.showFailure(context, failure.message);
      },
    );
  }

  void _confirmDeleteAppointment(AppointmentEntity appointment) {
    final patientName = viewModel.getPatientNameById(appointment.patientId);
    final appointmentDate = appointment.date;
    final appointmentTime = appointment.startTime;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Excluir Agendamento',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Text(
          'Deseja realmente excluir o agendamento de $patientName em $appointmentDate às $appointmentTime?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              viewModel.deleteAppointmentCommand.execute(appointment.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamentos'),
      ),
      body: ListenableBuilder(
        listenable: viewModel.patientsStreamCommand,
        builder: (context, _) {
          if (viewModel.patientsStreamCommand.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final patientsResult = viewModel.patientsStreamCommand.result;

          if (patientsResult == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return patientsResult.fold(
            (patients) {
              return _buildAppointmentsList();
            },
            (error) {
              return ErrorStateWidget(
                message: 'Erro ao carregar pacientes: ${error.message}',
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Modular.to.pushNamed('./register'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAppointmentsList() {
    return ListenableBuilder(
      listenable: viewModel.appointmentsStreamCommand,
      builder: (context, _) {
        if (viewModel.appointmentsStreamCommand.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final result = viewModel.appointmentsStreamCommand.result;

        if (result == null) {
          return const EmptyStateWidget();
        }

        return result.fold(
          (appointments) {
            if (appointments.isEmpty) {
              return const EmptyStateWidget();
            }

            // Sort appointments by date
            appointments.sort((a, b) {
              int dateComparison = a.date.compareTo(b.date);
              if (dateComparison != 0) return dateComparison;
              return a.startTime.compareTo(b.startTime);
            });

            return _buildAppointmentList(appointments);
          },
          (error) {
            return ErrorStateWidget(
              message: error.message,
            );
          },
        );
      },
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
}
