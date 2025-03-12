import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/features/appointment/domain/entities/appointment_entity.dart';
import 'package:flutter_therapy_evolution/app/features/appointment/presentation/appointment_viewmodel.dart';
import 'package:intl/intl.dart';

import '../../../core/alert/alerts.dart';
import '../../patient/domain/repositories/i_patient_repository.dart';
import '../../patient/presentation/widgets/empty_state_widget.dart';
import '../../patient/presentation/widgets/error_state_widget.dart';

class AppointmentListPage extends StatefulWidget {
  const AppointmentListPage({super.key});

  @override
  State<AppointmentListPage> createState() => _AppointmentListPageState();
}

class _AppointmentListPageState extends State<AppointmentListPage> {
  final viewModel = Modular.get<AppointmentViewmodel>();
  final patientRepository = Modular.get<IPatientRepository>();

  final Map<String, String> _patientNames = {};
  bool _isLoadingPatients = false;

  @override
  void initState() {
    super.initState();
    _loadPatientNames();
    viewModel.deleteAppointmentCommand.addListener(_onDeleteAppointment);
  }

  @override
  void dispose() {
    viewModel.appointmentsStreamCommand.dispose();
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
    final patientName = _getPatientName(appointment.patientId);
    final appointmentDate =
        DateFormat('dd/MM/yyyy').format(appointment.appointmentDateTime);
    final appointmentTime =
        DateFormat('HH:mm').format(appointment.appointmentDateTime);

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

  void _loadPatientNames() {
    setState(() => _isLoadingPatients = true);

    patientRepository.getPatientsStream().listen(
      (result) {
        result.fold(
          (patients) {
            final patientNames = <String, String>{};
            for (final patient in patients) {
              patientNames[patient.id] = patient.name;
            }

            setState(() {
              _patientNames.addAll(patientNames);
              _isLoadingPatients = false;
            });
          },
          (error) {
            Alerts.showFailure(context, error.message);
            setState(() => _isLoadingPatients = false);
          },
        );
      },
      onError: (error) {
        Alerts.showFailure(context, 'Erro ao carregar pacientes');
        setState(() => _isLoadingPatients = false);
      },
    );
  }

  String _getPatientName(String patientId) {
    return _patientNames[patientId] ?? 'Paciente não encontrado';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamentos'),
      ),
      body: _isLoadingPatients
          ? const Center(child: CircularProgressIndicator())
          : ListenableBuilder(
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

                    // Sort appointments by date (most recent first)
                    appointments.sort((a, b) =>
                        a.appointmentDateTime.compareTo(b.appointmentDateTime));

                    return _buildAppointmentList(appointments);
                  },
                  (error) {
                    return ErrorStateWidget(
                      message: error.message,
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Modular.to.pushNamed('./schedule'),
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
        final patientName = _getPatientName(appointment.patientId);

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
                  'Data: ${DateFormat('dd/MM/yyyy').format(appointment.appointmentDateTime)}',
                ),
                Text(
                  'Horário: ${DateFormat('HH:mm').format(appointment.appointmentDateTime)}',
                ),
                if (appointment.notes.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text('Obs: ${appointment.notes}'),
                ],
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDeleteAppointment(appointment),
            ),
          ),
        );
      },
    );
  }
}
