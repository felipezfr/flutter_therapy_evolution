import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/command/command_stream_listenable_builder.dart';
import 'package:flutter_therapy_evolution/app/core/widgets/result_handler.dart';
import 'package:intl/intl.dart';

import '../../../../core/alert/alerts.dart';
import '../../../patient/domain/entities/patient_entity.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/appointment_status_enum.dart';
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
  String? _selectedPatientId;
  AppointmentStatus _appointmentStatus = AppointmentStatus.scheduled;

  bool _isEditing = false;
  bool _isRegisterByPatient = false;
  AppointmentEntity? _appointmentToEdit;

  // Duration
  final List<int> _durationsDefault = [30, 45, 60, 90, 120];
  int _durationMinutes = 60; // Default duration of 60 minutes
  bool _isCustomDuration = false;
  final _customDurationController = TextEditingController();

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

      if (_durationsDefault.contains(appointment!.durationMinutes)) {
        _durationMinutes = appointment!.durationMinutes;
      } else {
        _isCustomDuration = true;
        _customDurationController.text =
            appointment!.durationMinutes.toString();
      }

      // Converter a data de string para DateTime
      try {
        _selectedDate = appointment!.date;
      } catch (e) {
        // Fallback para data atual se houver erro de parsing
        _selectedDate = DateTime.now();
      }

      // Converter horários de string para TimeOfDay
      try {
        _selectedStartTime = TimeOfDay(
          hour: appointment!.date.hour,
          minute: appointment!.date.minute,
        );
      } catch (e) {
        // Fallback para horários padrão se houver erro de parsing
        _selectedStartTime = TimeOfDay.now();
      }
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _typeController.dispose();
    _customDurationController.dispose();
    viewModel.saveAppointmentCommand.removeListener(_listener);
    super.dispose();
  }

  Future<void> _saveAppointment() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedPatientId == null) {
        Alerts.showFailure(context, 'Selecione um paciente');
        return;
      }

      DateTime date = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedStartTime.hour,
        _selectedStartTime.minute,
      );

      final appointment = AppointmentEntity(
        id: _isEditing ? _appointmentToEdit!.id : '',
        patientId: _selectedPatientId!,
        date: date,
        durationMinutes: _durationMinutes, // Use the selected duration
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
                  labelText: 'Horário',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                child: Text(
                  _selectedStartTime.format(context),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Duration selection
            _buildDurationField(),
            const SizedBox(height: 16),
            // Appointment Status
            DropdownButtonFormField<AppointmentStatus>(
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              value: _appointmentStatus,
              items: AppointmentStatus.values.map((status) {
                return DropdownMenuItem<AppointmentStatus>(
                  value: status,
                  child: Text(status.label),
                );
              }).toList(),
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

  Widget _buildDurationField() {
    return Column(
      children: [
        DropdownButtonFormField<dynamic>(
          decoration: const InputDecoration(
            labelText: 'Duração (minutos)',
            border: OutlineInputBorder(),
          ),
          value: _isCustomDuration ? 'custom' : _durationMinutes,
          items: [
            ...(_durationsDefault.map((duration) {
              return DropdownMenuItem<int>(
                value: duration,
                child: Text('$duration minutos'),
              );
            })),
            const DropdownMenuItem<String>(
              value: 'custom',
              child: Text('Personalizado'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              if (value == 'custom') {
                _isCustomDuration = true;
                _customDurationController.text = _durationMinutes.toString();
              } else {
                _isCustomDuration = false;
                _durationMinutes = value as int;
              }
            });
          },
        ),
        if (_isCustomDuration) ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: _customDurationController,
            decoration: const InputDecoration(
              labelText: 'Digite a duração em minutos',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Digite a duração';
              }
              final duration = int.tryParse(value);
              if (duration == null || duration <= 0) {
                return 'Digite um valor válido';
              }
              return null;
            },
            onChanged: (value) {
              final duration = int.tryParse(value);
              if (duration != null && duration > 0) {
                _durationMinutes = duration;
              }
            },
          ),
        ],
      ],
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
      });
    }
  }

  void _selectPatientAndBlockDropdown() {
    setState(() {
      _selectedPatientId = widget.patient!.id;
    });
  }
}
