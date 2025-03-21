import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/command/command_stream_listenable_builder.dart';
import 'package:flutter_therapy_evolution/app/core/utils/date_time_utils.dart';
import 'package:flutter_therapy_evolution/app/core/widgets/result_handler.dart';
import 'package:flutter_therapy_evolution/app/features/appointment/domain/entities/appointment_entity.dart';
import 'package:flutter_therapy_evolution/app/features/patient/domain/entities/patient_entity.dart';
import '../../domain/entities/clinical_record_entity.dart';
import '../../domain/entities/prescription_entity.dart';

import '../viewmodels/clinical_record_viewmodel.dart';

class PatientClinicalRecordRegisterPage extends StatefulWidget {
  final PatientEntity patient;
  final ClinicalRecordEntity? clinicalRecord;

  const PatientClinicalRecordRegisterPage({
    super.key,
    required this.patient,
    this.clinicalRecord,
  });

  @override
  State<PatientClinicalRecordRegisterPage> createState() =>
      _PatientClinicalRecordRegisterPageState();
}

class _PatientClinicalRecordRegisterPageState
    extends State<PatientClinicalRecordRegisterPage> {
  final viewModel = Modular.get<ClinicalRecordViewmodel>();
  final _formKey = GlobalKey<FormState>();
  PatientEntity get patient => widget.patient;
  bool isEditMode = false;

  // Form controllers
  final _chiefComplaintController = TextEditingController();
  final _presentIllnessController = TextEditingController();
  final _physicalExamController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _planController = TextEditingController();
  final _recommendationsController = TextEditingController();
  // Prescriptions list
  final List<PrescriptionEntity> _prescriptions = [];
  // Attachments list
  final List<String> _attachments = [];

  String? _selectedAppointmentId;
  DateTime? _consultationDate;

  @override
  void initState() {
    super.initState();
    //Commands
    viewModel.appointmentsPatientStream.execute(patient.id);
    viewModel.savePatientClinicalRecordCommand
        .addListener(_saveClinicalRecordListener);

    isEditMode = widget.clinicalRecord != null;

    if (isEditMode) {
      _loadClinicalRecord();
    }
  }

  void _loadClinicalRecord() {
    final clinicalRecord = widget.clinicalRecord!;

    _selectedAppointmentId = clinicalRecord.appointmentId;

    _chiefComplaintController.text = clinicalRecord.chiefComplaint ?? '';
    _presentIllnessController.text = clinicalRecord.presentIllness ?? '';
    _physicalExamController.text = clinicalRecord.physicalExam ?? '';
    _diagnosisController.text = clinicalRecord.diagnosis ?? '';
    _planController.text = clinicalRecord.plan ?? '';
    _recommendationsController.text = clinicalRecord.recommendations ?? '';

    if (clinicalRecord.prescriptions != null) {
      _prescriptions.addAll(clinicalRecord.prescriptions!);
    }

    if (clinicalRecord.attachments != null) {
      _attachments.addAll(clinicalRecord.attachments!);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _chiefComplaintController.dispose();
    _presentIllnessController.dispose();
    _physicalExamController.dispose();
    _diagnosisController.dispose();
    _planController.dispose();
    _recommendationsController.dispose();
    //Commands
    viewModel.appointmentsPatientStream.dispose();
    viewModel.savePatientClinicalRecordCommand
        .removeListener(_saveClinicalRecord);
    super.dispose();
  }

  void _saveClinicalRecordListener() {
    ResultHandler.showAlert(
      context: context,
      result: viewModel.savePatientClinicalRecordCommand.result,
      successMessage: isEditMode
          ? 'Evolução clínica atualizada com sucesso!'
          : 'Evolução clínica cadastrada com sucesso!',
      onSuccess: (value) {
        Modular.to.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode
            ? 'Editar evolução do paciente'
            : 'Cadastrar evolução do paciente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Patient info card
              CommandStreamListenableBuilder<List<AppointmentEntity>>(
                  stream: viewModel.appointmentsPatientStream,
                  showEmptyState: false,
                  builder: (context, appointments) {
                    List<AppointmentEntity> filteredAppointments = [];
                    if (appointments.isNotEmpty) {
                      appointments.sort((a, b) => b.date.compareTo(a.date));
                      filteredAppointments = appointments
                          .where(
                            (e) => e.date.isBefore(DateTime.now()),
                          )
                          .toList();

                      _selectedAppointmentId ??= filteredAppointments.first.id;
                    } else {
                      _selectedAppointmentId = 'anotherDate';
                    }

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Paciente: ${patient.name}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Selecione a data do atendimento:',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            if (filteredAppointments.isNotEmpty) ...[
                              Column(
                                children: [
                                  DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Data do atendimento',
                                    ),
                                    value: _selectedAppointmentId,
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: 'anotherDate',
                                        child: Text('Outra data'),
                                      ),
                                      ...filteredAppointments
                                          .map((appointment) {
                                        return DropdownMenuItem<String>(
                                          value: appointment.id,
                                          child: Text(
                                            DateTimeUtils
                                                .formateDateWithWeekName(
                                              appointment.date,
                                            ),
                                          ),
                                        );
                                      })
                                    ],
                                    onChanged: (String? appointmentId) {
                                      _selectedAppointmentId = appointmentId;
                                      final appointment = filteredAppointments
                                          .where(
                                            (element) =>
                                                element.id == appointmentId,
                                          )
                                          .firstOrNull;
                                      _consultationDate = appointment?.date;
                                      setState(() {});
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                            ],
                            if (_selectedAppointmentId == 'anotherDate') ...[
                              Column(
                                children: [
                                  PrimaryButtonDs(
                                    onPressed: () async {
                                      DateTime? selectedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2025),
                                        lastDate: DateTime(2030),
                                      );

                                      if (selectedDate != null) {
                                        TimeOfDay? selectedTime =
                                            await showTimePicker(
                                          // ignore: use_build_context_synchronously
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );

                                        if (selectedTime != null) {
                                          // Combine date and time into a single DateTime object
                                          final dateTime = DateTime(
                                            selectedDate.year,
                                            selectedDate.month,
                                            selectedDate.day,
                                            selectedTime.hour,
                                            selectedTime.minute,
                                          );
                                          setState(() {
                                            _consultationDate = dateTime;
                                          });
                                        }
                                      }
                                    },
                                    title: 'Escolher data e horário',
                                  ),
                                  if (_consultationDate != null) ...[
                                    const SizedBox(height: 10),
                                    Text(
                                      DateTimeUtils.formateDate(
                                          _consultationDate!),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    )
                                  ]
                                ],
                              ),
                            ]
                          ],
                        ),
                      ),
                    );
                  }),
              const SizedBox(height: 16),
              // Clinical record form
              Text(
                'Dados da Evolução',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildFormField(
                label: 'Queixa principal',
                controller: _chiefComplaintController,
                maxLines: 3,
              ),
              _buildFormField(
                label: 'História da doença atual',
                controller: _presentIllnessController,
                maxLines: 5,
              ),
              _buildFormField(
                label: 'Exame físico',
                controller: _physicalExamController,
                maxLines: 5,
              ),
              _buildFormField(
                label: 'Diagnóstico',
                controller: _diagnosisController,
                maxLines: 3,
              ),
              _buildFormField(
                label: 'Plano',
                controller: _planController,
                maxLines: 5,
              ),
              _buildFormField(
                label: 'Recomendações',
                controller: _recommendationsController,
                maxLines: 5,
              ),
              const SizedBox(height: 24),
              ListenableBuilder(
                listenable: viewModel.savePatientClinicalRecordCommand,
                builder: (context, _) {
                  return PrimaryButtonDs(
                    isLoading:
                        viewModel.savePatientClinicalRecordCommand.running,
                    title:
                        isEditMode ? 'Atualizar Evolução' : 'Salvar Evolução',
                    onPressed: _saveClinicalRecord,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveClinicalRecord() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final clinicalRecord = ClinicalRecordEntity(
      id: isEditMode ? widget.clinicalRecord!.id : '',
      patientId: patient.id,
      appointmentId: _selectedAppointmentId,
      date: _consultationDate!,
      chiefComplaint: _chiefComplaintController.text,
      presentIllness: _presentIllnessController.text,
      physicalExam: _physicalExamController.text,
      diagnosis: _diagnosisController.text,
      plan: _planController.text,
      prescriptions: _prescriptions,
      recommendations: _recommendationsController.text,
      attachments: _attachments,
    );

    await viewModel.savePatientClinicalRecordCommand.execute(clinicalRecord);
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: isRequired
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo é obrigatório';
                }
                return null;
              }
            : null,
      ),
    );
  }
}
