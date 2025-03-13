import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import '../../../core/alert/alerts.dart';
import '../../patient/domain/entities/patient_entity.dart';
import '../domain/entities/appointment_entity.dart';
import 'appointment_viewmodel.dart';

class AppointmentSchedulePage extends StatefulWidget {
  final String? patientId;

  const AppointmentSchedulePage({
    super.key,
    this.patientId,
  });

  @override
  State<AppointmentSchedulePage> createState() =>
      _AppointmentSchedulePageState();
}

class _AppointmentSchedulePageState extends State<AppointmentSchedulePage> {
  final viewModel = Modular.get<AppointmentViewmodel>();

  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _typeController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay(
    hour: TimeOfDay.now().hour + 1,
    minute: TimeOfDay.now().minute,
  );
  String? _selectedPatientId;
  String _appointmentStatus = 'scheduled';

  @override
  void initState() {
    super.initState();
    _selectedPatientId = widget.patientId;
    viewModel.saveAppointmentCommand.addListener(_saveAppointmentListener);
  }

  @override
  void dispose() {
    _notesController.dispose();
    _typeController.dispose();
    viewModel.saveAppointmentCommand.removeListener(_saveAppointmentListener);
    super.dispose();
  }

  void _saveAppointmentListener() {
    viewModel.saveAppointmentCommand.result?.fold(
      (success) {
        Alerts.showSuccess(context, 'Agendamento salvo com sucesso!');
        _notesController.clear();
        _typeController.clear();
        Modular.to.pop();
      },
      (failure) {
        Alerts.showFailure(context, failure.message);
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime,
    );
    if (picked != null && picked != _selectedStartTime) {
      setState(() {
        _selectedStartTime = picked;

        // Automatically set end time 1 hour after start time
        _selectedEndTime = TimeOfDay(
          hour: picked.hour + 1,
          minute: picked.minute,
        );
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime,
    );
    if (picked != null && picked != _selectedEndTime) {
      setState(() {
        _selectedEndTime = picked;
      });
    }
  }

  Future<void> _saveAppointment() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedPatientId == null) {
        Alerts.showFailure(context, 'Selecione um paciente');
        return;
      }

      final dateFormatted = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final startTimeFormatted = _selectedStartTime.format(context);
      final endTimeFormatted = _selectedEndTime.format(context);

      final currentUserId = await viewModel.getCurrentUserId();

      final appointment = AppointmentEntity(
        id: '',
        patientId: _selectedPatientId!,
        professionalId: currentUserId,
        date: dateFormatted,
        startTime: startTimeFormatted,
        endTime: endTimeFormatted,
        type: _typeController.text.trim(),
        status: _appointmentStatus,
        notes: _notesController.text.trim(),
        reminderSent: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      viewModel.saveAppointmentCommand.execute(appointment);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Consulta'),
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
              return _buildForm(patients);
            },
            (error) {
              return Center(
                child: Text('Erro ao carregar pacientes: ${error.message}'),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildForm(List<PatientEntity> patients) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Patient selection
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Paciente',
                border: OutlineInputBorder(),
              ),
              value: _selectedPatientId,
              items: patients.map((patient) {
                return DropdownMenuItem<String>(
                  value: patient.id,
                  child: Text(patient.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPatientId = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Selecione um paciente';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Date selection
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Data',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  DateFormat('dd/MM/yyyy').format(_selectedDate),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Start Time selection
            InkWell(
              onTap: () => _selectStartTime(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Horário de Início',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                child: Text(
                  _selectedStartTime.format(context),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // End Time selection
            InkWell(
              onTap: () => _selectEndTime(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Horário de Término',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                child: Text(
                  _selectedEndTime.format(context),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Appointment Type
            TextFormField(
              controller: _typeController,
              decoration: const InputDecoration(
                labelText: 'Tipo de Consulta',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o tipo de consulta';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Appointment Status
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              value: _appointmentStatus,
              items: const [
                DropdownMenuItem(value: 'scheduled', child: Text('Agendado')),
                DropdownMenuItem(value: 'confirmed', child: Text('Confirmado')),
                DropdownMenuItem(value: 'completed', child: Text('Concluído')),
                DropdownMenuItem(value: 'canceled', child: Text('Cancelado')),
                DropdownMenuItem(
                    value: 'noShow', child: Text('Não Compareceu')),
              ],
              onChanged: (value) {
                setState(() {
                  _appointmentStatus = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Observações',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Save button
            PrimaryButtonDs(
              onPressed: _saveAppointment,
              title: 'Salvar agendamento',
            ),
          ],
        ),
      ),
    );
  }
}
