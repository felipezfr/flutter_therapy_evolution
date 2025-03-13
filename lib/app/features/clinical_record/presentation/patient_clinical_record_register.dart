import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/alert/alerts.dart';
import 'package:flutter_therapy_evolution/app/features/patient/domain/entities/patient_entity.dart';
import '../domain/entities/clinical_record_entity.dart';
import '../domain/entities/prescription_entity.dart';

import 'clinical_record_viewmodel.dart';

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

  // Form controllers
  final _chiefComplaintController = TextEditingController();
  final _presentIllnessController = TextEditingController();
  final _physicalExamController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _planController = TextEditingController();
  final _recommendationsController = TextEditingController();

  bool isEditMode = false;

  // Prescriptions list
  final List<PrescriptionEntity> _prescriptions = [];

  // Attachments list
  final List<String> _attachments = [];

  PatientEntity get patient => widget.patient;

  @override
  void initState() {
    super.initState();

    viewModel.savePatientClinicalRecordCommand
        .addListener(_savePatientListener);

    isEditMode = widget.clinicalRecord != null;

    if (isEditMode) {
      _loadClinicalRecord();
    }
  }

  void _loadClinicalRecord() {
    final clinicalRecord = widget.clinicalRecord!;
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
  }

  @override
  void dispose() {
    _chiefComplaintController.dispose();
    _presentIllnessController.dispose();
    _physicalExamController.dispose();
    _diagnosisController.dispose();
    _planController.dispose();
    _recommendationsController.dispose();
    viewModel.savePatientClinicalRecordCommand
        .removeListener(_saveClinicalRecord);
    super.dispose();
  }

  Future<void> _saveClinicalRecord() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final clinicalRecord = ClinicalRecordEntity(
      id: isEditMode ? widget.clinicalRecord!.id : '',
      patientId: patient.id,
      professionalId: patient.responsibleProfessional,
      date: isEditMode
          ? widget.clinicalRecord!.date
          : DateTime.now().toIso8601String(),
      chiefComplaint: _chiefComplaintController.text,
      presentIllness: _presentIllnessController.text,
      physicalExam: _physicalExamController.text,
      diagnosis: _diagnosisController.text,
      plan: _planController.text,
      prescriptions: _prescriptions,
      recommendations: _recommendationsController.text,
      attachments: _attachments,
      createdAt: isEditMode ? widget.clinicalRecord!.createdAt : DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await viewModel.savePatientClinicalRecordCommand.execute(clinicalRecord);
  }

  void _savePatientListener() {
    viewModel.savePatientClinicalRecordCommand.result?.fold(
      (success) {
        if (mounted) {
          Alerts.showSuccess(
              context,
              isEditMode
                  ? 'Evolução clínica atualizada com sucesso!'
                  : 'Evolução clínica cadastrada com sucesso!');
        }
        // _clearForm();
        Modular.to.pop();
      },
      (failure) {
        if (mounted) {
          Alerts.showFailure(context, failure.message);
        }
      },
    );
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Paciente: ${patient.name}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Data de nascimento: ${patient.birthDate.day}/${patient.birthDate.month}/${patient.birthDate.year}',
                      ),
                      Text('Documento: ${patient.documentId}'),
                    ],
                  ),
                ),
              ),
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
}
