import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/alert/alerts.dart';
import 'package:flutter_therapy_evolution/app/core/widgets/result_handler.dart';

import '../../../patient/domain/entities/patient_entity.dart';
import '../viewmodels/consultation_viewmodel.dart';
import '../../domain/entities/consultation_entity.dart';

class ConsultationRegisterPage extends StatefulWidget {
  final ConsultationEntity? consultation;
  final PatientEntity? patient;

  const ConsultationRegisterPage({
    super.key,
    this.patient,
    this.consultation,
  });

  @override
  State<ConsultationRegisterPage> createState() =>
      _ConsultationRegisterPageState();
}

class _ConsultationRegisterPageState extends State<ConsultationRegisterPage> {
  final viewModel = Modular.get<ConsultationViewmodel>();
  ConsultationEntity? get consultation => widget.consultation;
  bool _isEditMode = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel.saveConsultationCommand.addListener(_saveConsultationListener);

    _isEditMode = widget.consultation != null;

    if (_isEditMode) {
      _loadConsultation();
    }
  }

  void _loadConsultation() {
    _nameController.text = consultation!.name;
  }

  void _saveConsultationListener() {
    ResultHandler.showAlert(
      context: context,
      result: viewModel.saveConsultationCommand.result,
      successMessage:
          _isEditMode ? 'Atualizado com sucesso!' : 'Cadastrado com sucesso!',
      onSuccess: (value) {
        Modular.to.pop();
      },
    );
  }

  void _saveConsultation() {
    if (_formKey.currentState!.validate()) {
      try {
        final patientId = widget.patient?.id != null
            ? widget.patient!.id
            : widget.consultation!.patientId;

        final newConsultation = ConsultationEntity(
          id: _isEditMode ? consultation!.id : '',
          patientId: patientId,
          name: _nameController.text,
        );

        viewModel.saveConsultationCommand.execute(newConsultation);
      } catch (e) {
        Alerts.showFailure(context, 'Erro ao salvar');
      }
    }
  }

  @override
  void dispose() {
    viewModel.saveConsultationCommand.removeListener(_saveConsultationListener);
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Editar' : 'Cadastrar'),
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o nome';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            PrimaryButtonDs(
              isLoading: viewModel.saveConsultationCommand.running,
              onPressed: _saveConsultation,
              title: _isEditMode ? 'Salvar Alterações' : 'Cadastrar',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
