import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/widgets/delete_dialog.dart';
import 'package:flutter_therapy_evolution/app/features/appointment/domain/entities/appointment_entity.dart';
import 'package:intl/intl.dart';
import '../../../../core/command/command_stream_listenable_builder.dart';
import '../../../../core/widgets/result_handler.dart';
import '../../../home/presentation/widgets/custom_bottom_navigator_bar.dart';
import '../viewmodels/appointment_viewmodel.dart';
import 'widgets/appointment_card.dart';
import 'widgets/calendar_strip.dart';
import 'widgets/day_header_widget.dart';
import 'widgets/delete_appointment_dialog.dart';
import 'widgets/time_widget.dart';
import '../../domain/enums/recurrence_type_enum.dart';

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
  int? _currentYear;
  int? _currentMonth;

  @override
  void initState() {
    super.initState();

    viewModel.allAppointmentsStreamCommand
        .execute((selectedDate.year, selectedDate.month));
    viewModel.deleteAppointmentCommand.addListener(_listener);
    viewModel.deleteRecurringAppointmentsCommand
        .addListener(_recurringDeleteListener);
  }

  @override
  void dispose() {
    //List All appointments
    viewModel.allAppointmentsStreamCommand.dispose();
    //Delete
    viewModel.deleteAppointmentCommand.removeListener(_listener);
    viewModel.deleteRecurringAppointmentsCommand
        .removeListener(_recurringDeleteListener);
    super.dispose();
  }

  void _onSelectedDateChanged() {
    final date = selectedDate;
    if (_currentYear != date.year || _currentMonth != date.month) {
      _currentYear = date.year;
      _currentMonth = date.month;
      viewModel.allAppointmentsStreamCommand.execute((date.year, date.month));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.primaryLigth,
      body: SafeArea(
        child: Column(
          children: [
            DayHeaderWidget(
              date: selectedDate,
              onDateChanged: (date) {
                setState(() {
                  selectedDate = date;
                  _onSelectedDateChanged();
                });
              },
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
                child: CommandStreamListenableBuilder<List<AppointmentEntity>>(
                  stream: viewModel.allAppointmentsStreamCommand,
                  emptyMessage:
                      'Voce não possui nenhum agendamento cadastrado no mês de ${DateFormat('MMMM').format(selectedDate)}',
                  emptyIconData: Icons.calendar_month_rounded,
                  builder: (context, value) {
                    return Column(
                      children: [
                        const SizedBox(height: 18),
                        CalendarStrip(
                          initialDate: selectedDate,
                          checkedDays: value.map((e) => e.date.day).toList(),
                          onDateSelected: (date) {
                            setState(() {
                              selectedDate = date;
                              _onSelectedDateChanged();
                            });
                          },
                        ),
                        Expanded(child: _buildAppointmentList(value)),
                      ],
                    );
                  },
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

    final appointmentsFiltered = appointments
        .where(
          (element) =>
              element.date.year == selectedDate.year &&
              element.date.month == selectedDate.month &&
              element.date.day == selectedDate.day,
        )
        .toList();

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
            itemCount: appointmentsFiltered.length,
            itemBuilder: (context, index) {
              final appointment = appointmentsFiltered[index];
              final patient = viewModel.getPatientById(appointment.patientId);

              final isNow = isAppointmentNow(appointment);

              return SizedBox(
                height: 150,
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

  bool isAppointmentNow(AppointmentEntity appointment) {
    final now = DateTime.now();

    // Horário de início da consulta
    final startTime = appointment.date;

    // Horário de término (data inicial + duração em minutos)
    final endTime =
        startTime.add(Duration(minutes: appointment.durationMinutes));

    // Verifica se o horário atual está entre o início e fim da consulta
    return now.isAfter(startTime) && now.isBefore(endTime);
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

  void _recurringDeleteListener() {
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
      DeleteAppointmentDialog.showRecurringDelete(
        context: context,
        patientName: patientName,
        appointmentDate: appointmentDate,
        onConfirmOnlyThis: () {
          viewModel.deleteAppointmentCommand.execute(appointment.id);
        },
        onConfirmAll: () {
          viewModel.deleteRecurringAppointmentsCommand
              .execute(appointment.recurringGroupId!);
        },
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
