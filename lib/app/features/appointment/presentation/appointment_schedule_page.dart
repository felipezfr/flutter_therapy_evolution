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

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String? _selectedPatientId;
  // List<PatientEntity> _patients = [];

  @override
  void initState() {
    super.initState();
    _selectedPatientId = widget.patientId;
    viewModel.saveAppointmentCommand.addListener(_saveAppointmentListener);
  }

  @override
  void dispose() {
    _notesController.dispose();
    viewModel.saveAppointmentCommand.removeListener(_saveAppointmentListener);
    super.dispose();
  }

  void _saveAppointmentListener() {
    viewModel.saveAppointmentCommand.result?.fold(
      (success) {
        Alerts.showSuccess(context, 'Agendamento salvo com sucesso!');
        _notesController.clear();
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveAppointment() {
    if (_formKey.currentState!.validate()) {
      if (_selectedPatientId == null) {
        Alerts.showFailure(context, 'Selecione um paciente');
        return;
      }

      final appointmentDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final appointment = AppointmentEntity(
        id: '',
        patientId: _selectedPatientId!,
        appointmentDateTime: appointmentDateTime,
        notes: _notesController.text.trim(),
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
              // _patients = patients;
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

            // Time selection
            InkWell(
              onTap: () => _selectTime(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Horário',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                child: Text(
                  _selectedTime.format(context),
                ),
              ),
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
