import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/widgets/delete_dialog.dart';
import 'package:flutter_therapy_evolution/app/features/appointment/domain/entities/appointment_entity.dart';
import '../../../../core/command/command_stream_listenable_builder.dart';
import '../../../../core/widgets/result_handler.dart';
import '../viewmodels/appointment_viewmodel.dart';
import 'widgets/appointment_card.dart';
import 'widgets/calendar_strip.dart';
import 'widgets/time_widget.dart';

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
      body: Column(
        children: [
          CalendarStrip(),
          Expanded(
            child: CommandStreamListenableBuilder<List<AppointmentEntity>>(
              stream: viewModel.allAppointmentsStreamCommand,
              emptyMessage: 'Voce não possui nenhum agendamento cadastrado',
              emptyIconData: Icons.calendar_month_rounded,
              builder: (context, value) {
                return _buildAppointmentList(value);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToRegisterPage,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAppointmentList(List<AppointmentEntity> appointments) {
    // final size = MediaQuery.sizeOf(context);
    // final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Text(
                  'Horário',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textGreyColor,
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                child: Text(
                  '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textGreyColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final patient = viewModel.getPatientById(appointment.patientId);

              final isNow = index == 0 ? true : false;

              return SizedBox(
                height: 160,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TimeWidget(appointment: appointment),
                    ),
                    Expanded(
                      flex: 5,
                      child: AppointmentCard(
                        patient: patient!,
                        appointment: appointment,
                        isSelected: isNow,
                        onTap: () {
                          _navigateToDetailPage(appointment);
                        },
                        onTapEdit: () {
                          _navigateToEditPage(appointment);
                        },
                        onTapDelete: () {
                          _confirmDeleteAppointment(appointment);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
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
      title: 'Excluir Agendamento',
      entityName:
          'o agendamento de $patientName em $appointmentDate às $appointmentTime?',
      onConfirm: () {
        viewModel.deleteAppointmentCommand.execute(appointment.id);
      },
    );
  }
}
