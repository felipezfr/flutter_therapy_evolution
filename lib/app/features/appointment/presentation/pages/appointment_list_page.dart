import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/widgets/delete_dialog.dart';
import 'package:flutter_therapy_evolution/app/features/appointment/domain/entities/appointment_entity.dart';
import '../../../../core/command/command_stream_listenable_builder.dart';
import '../../../../core/widgets/result_handler.dart';
import '../../../home/presentation/widgets/custom_bottom_navigator_bar.dart';
import '../viewmodels/appointment_viewmodel.dart';
import 'widgets/appointment_card.dart';
import 'widgets/calendar_strip.dart';
import 'widgets/day_header_widget.dart';
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

  DateTime selectedDate = DateTime.now();

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
      backgroundColor: AppColors.primaryLigth,
      body: SafeArea(
        child: Column(
          children: [
            DayHeaderWidget(
              date: selectedDate,
            ),
            const SizedBox(height: 14),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 18),
                    CalendarStrip(
                      onDateSelected: (date) {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                    ),
                    Expanded(
                      child: CommandStreamListenableBuilder<
                          List<AppointmentEntity>>(
                        stream: viewModel.allAppointmentsStreamCommand,
                        emptyMessage:
                            'Voce não possui nenhum agendamento cadastrado',
                        emptyIconData: Icons.calendar_month_rounded,
                        builder: (context, value) {
                          return _buildAppointmentList(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToRegisterPage,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  Widget _buildAppointmentList(List<AppointmentEntity> appointments) {
    // final size = MediaQuery.sizeOf(context);
    // final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Text(
                  'Horário',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.greyDark,
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                child: Center(
                  child: Text(
                    'Consultas',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.greyDark,
                    ),
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
