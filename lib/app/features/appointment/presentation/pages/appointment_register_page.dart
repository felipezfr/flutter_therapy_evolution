import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/command/command_stream_listenable_builder.dart';
import 'package:flutter_therapy_evolution/app/core/widgets/result_handler.dart';
import 'package:intl/intl.dart';

import '../../../../core/alert/alerts.dart';
import '../../../patient/domain/entities/patient_entity.dart';
import '../../domain/entities/appointment_entity.dart';
import '../viewmodels/appointment_viewmodel.dart';

class AppointmentRegisterPage extends StatefulWidget {
  final AppointmentEntity? appointment;
  final PatientEntity? patient; //Used to set patient

  const AppointmentRegisterPage({
    super.key,
    this.appointment,
    this.patient,
  });

  @override
  State<AppointmentRegisterPage> createState() =>
      _AppointmentRegisterPageState();
}

class _AppointmentRegisterPageState extends State<AppointmentRegisterPage> {
  final viewModel = Modular.get<AppointmentViewmodel>();

  AppointmentEntity? get appointment => widget.appointment;

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

  bool _isEditing = false;
  bool _isRegisterByPatient = false;
  AppointmentEntity? _appointmentToEdit;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.appointment != null;
    _isRegisterByPatient = widget.patient != null;
    viewModel.saveAppointmentCommand.addListener(_listener);

    if (_isEditing) {
      _loadAppointmentData();
    } else if (_isRegisterByPatient) {
      _selectPatientAndBlockDropdown();
    }
  }

  void _loadAppointmentData() {
    setState(() {
      _appointmentToEdit = appointment;
      _selectedPatientId = appointment!.patientId;
      _typeController.text = appointment!.type;
      _notesController.text = appointment!.notes ?? '';
      _appointmentStatus = appointment!.status;

      // Converter a data de string para DateTime
      try {
        _selectedDate = DateFormat('yyyy-MM-dd').parse(appointment!.date);
      } catch (e) {
        // Fallback para data atual se houver erro de parsing
        _selectedDate = DateTime.now();
      }

      // Converter horários de string para TimeOfDay
      try {
        final startTimeParts = appointment!.startTime.split(':');
        if (startTimeParts.length >= 2) {
          _selectedStartTime = TimeOfDay(
            hour: int.parse(startTimeParts[0]),
            minute: int.parse(startTimeParts[1]),
          );
        }

        final endTimeParts = appointment!.endTime.split(':');
        if (endTimeParts.length >= 2) {
          _selectedEndTime = TimeOfDay(
            hour: int.parse(endTimeParts[0]),
            minute: int.parse(endTimeParts[1]),
          );
        }
      } catch (e) {
        // Fallback para horários padrão se houver erro de parsing
        _selectedStartTime = TimeOfDay.now();
        _selectedEndTime = TimeOfDay(
          hour: TimeOfDay.now().hour + 1,
          minute: TimeOfDay.now().minute,
        );
      }
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _typeController.dispose();
    viewModel.saveAppointmentCommand.removeListener(_listener);
    super.dispose();
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

      final appointment = AppointmentEntity(
        id: _isEditing ? _appointmentToEdit!.id : '',
        patientId: _selectedPatientId!,
        date: dateFormatted,
        startTime: startTimeFormatted,
        endTime: endTimeFormatted,
        type: _typeController.text.trim(),
        status: _appointmentStatus,
        notes: _notesController.text.trim(),
        reminderSent: _isEditing ? _appointmentToEdit!.reminderSent : false,
      );

      viewModel.saveAppointmentCommand.execute(appointment);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Consulta' : 'Agendar Consulta'),
      ),
      body: CommandStreamListenableBuilder<List<PatientEntity>>(
        stream: viewModel.patientsStreamCommand,
        emptyMessage: 'Voce ainda não possui nenhum paciente cadastrado',
        emptyHowRegisterMessage:
            'Vá para a tela de pacientes e cadastre seu primeiro paciente',
        emptyIconData: Icons.person_add_disabled,
        errorMessage: 'Erro ao carregar pacientes',
        builder: (context, value) {
          return _buildForm(value);
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
              isLoading: viewModel.saveAppointmentCommand.running,
              title:
                  _isEditing ? 'Atualizar agendamento' : 'Salvar agendamento',
            ),
          ],
        ),
      ),
    );
  }

  void _listener() {
    ResultHandler.showAlert(
      context: context,
      result: viewModel.saveAppointmentCommand.result,
      successMessage: 'Agendamento salvo com sucesso!',
      onSuccess: (value) {
        Modular.to.pop();
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

  void _selectPatientAndBlockDropdown() {
    setState(() {
      _selectedPatientId = widget.patient!.id;
    });
  }
}
