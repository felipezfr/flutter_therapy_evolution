import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/widgets/result_handler.dart';
import 'package:flutter_therapy_evolution/app/features/appointment/domain/entities/appointment_entity.dart';
import 'package:flutter_therapy_evolution/app/features/appointment/presentation/pages/widgets/appointment_card.dart';
import 'package:flutter_therapy_evolution/app/features/patient/domain/entities/patient_entity.dart';
import 'package:intl/intl.dart';

import '../../../../core/command/command_stream_listenable_builder.dart';
import '../../../../core/widgets/delete_dialog.dart';
import '../viewmodels/appointment_viewmodel.dart';
import '../../domain/enums/recurrence_type_enum.dart';

class PatientAppointmentListPage extends StatefulWidget {
  final String patientId;

  const PatientAppointmentListPage({
    super.key,
    required this.patientId,
  });

  @override
  State<PatientAppointmentListPage> createState() =>
      _PatientAppointmentListPageState();
}

class _PatientAppointmentListPageState
    extends State<PatientAppointmentListPage> {
  final viewModel = Modular.get<AppointmentViewmodel>();

  @override
  void initState() {
    super.initState();

    viewModel.patientAppointmentsStreamCommand.execute(widget.patientId);
    viewModel.patientStreamCommand.execute(widget.patientId);
    viewModel.deleteAppointmentCommand.addListener(_onDeleteAppointment);
    viewModel.deleteRecurringAppointmentsCommand
        .addListener(_onDeleteRecurringAppointment);
  }

  @override
  void dispose() {
    //List patient appointments
    viewModel.patientAppointmentsStreamCommand.dispose();
    viewModel.patientStreamCommand.execute(widget.patientId);
    //Delete appointment
    viewModel.deleteAppointmentCommand.removeListener(_onDeleteAppointment);
    viewModel.deleteRecurringAppointmentsCommand
        .removeListener(_onDeleteRecurringAppointment);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //TODO Ajustar para scafold ficar antes, se der erro fica tudo preto
    return CommandStreamListenableBuilder<PatientEntity>(
      stream: viewModel.patientStreamCommand,
      builder: (context, patient) {
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
              return _buildAppointmentList(value, patient);
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _navigateToRegisterAppointment(patient),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildAppointmentList(
      List<AppointmentEntity> appointments, PatientEntity patient) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];

        return AppointmentCard(
          patient: patient,
          appointment: appointment,
          onTap: () {
            _navigateToDetailPage(appointment);
          },
          onTapEdit: () {
            _navigateToEditAppointment(appointment);
          },
          onTapDelete: () {
            _confirmDeleteAppointment(appointment);
          },
          isSelected: false,
        );
      },
    );
  }

  void _navigateToRegisterAppointment(PatientEntity patient) {
    Modular.to.pushNamed(
      '../register',
      arguments: {
        'patientEntity': patient,
      },
    );
  }

  void _navigateToEditAppointment(AppointmentEntity appointment) {
    Modular.to.pushNamed(
      '../edit',
      arguments: {
        'appointmentEntity': appointment,
      },
    );
  }

  void _navigateToDetailPage(AppointmentEntity appointment) {
    Modular.to.pushNamed('../detail/${appointment.id}');
  }

  void _onDeleteAppointment() {
    ResultHandler.showAlert(
      context: context,
      result: viewModel.deleteAppointmentCommand.result,
      successMessage: 'Agendamento excluído com sucesso!',
    );
  }

  void _onDeleteRecurringAppointment() {
    ResultHandler.showAlert(
      context: context,
      result: viewModel.deleteRecurringAppointmentsCommand.result,
      successMessage: 'Série de agendamentos excluída com sucesso!',
    );
  }

  void _confirmDeleteAppointment(AppointmentEntity appointment) {
    final patientName = viewModel.getPatientNameById(appointment.patientId);
    final appointmentDate = appointment.date;

    // Check if this is a recurring appointment
    if (appointment.recurringGroupId != null &&
        appointment.recurrenceType != RecurrenceType.none) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Excluir Agendamento'),
          content: Text(
            'Deseja realmente excluir o agendamento de $patientName em ${DateFormat('dd/MM/yyyy HH:mm').format(appointmentDate)}?'
            '\n\nDeseja excluir apenas este agendamento ou toda a série?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Delete just this appointment
                viewModel.deleteAppointmentCommand.execute(appointment.id);
              },
              child: const Text('Apenas Este'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Delete all recurring appointments
                viewModel.deleteRecurringAppointmentsCommand
                    .execute(appointment.recurringGroupId!);
              },
              child: const Text('Toda a Série'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      );
    } else {
      // Regular non-recurring appointment deletion
      DeleteDialog.showDeleteConfirmation(
        context: context,
        title: 'Excluir Agendamento',
        entityName:
            'o agendamento de $patientName em ${DateFormat('dd/MM/yyyy HH:mm').format(appointmentDate)}',
        onConfirm: () {
          viewModel.deleteAppointmentCommand.execute(appointment.id);
        },
      );
    }
  }
}
