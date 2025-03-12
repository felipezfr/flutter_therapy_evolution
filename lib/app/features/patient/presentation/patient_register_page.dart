import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'patient_viewmodel.dart';

import '../../../core/alert/alerts.dart';
import '../domain/entities/patient_entity.dart';

class PatientRegisterPage extends StatefulWidget {
  final PatientEntity? patient;

  const PatientRegisterPage({
    super.key,
    this.patient,
  });

  @override
  State<PatientRegisterPage> createState() => _PatientRegisterPageState();
}

class _PatientRegisterPageState extends State<PatientRegisterPage> {
  final viewModel = Modular.get<PatientViewmodel>();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  PatientEntity? get patient => widget.patient;

  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    viewModel.savePatientCommand.addListener(_savePatientListener);

    _isEditMode = widget.patient != null && widget.patient!.id.isNotEmpty;

    if (_isEditMode) {
      _loadPatient();
    }
  }

  void _loadPatient() {
    _nameController.text = widget.patient!.name;
  }

  void _savePatientListener() {
    viewModel.savePatientCommand.result?.fold(
      (success) {
        Alerts.showSuccess(
            context,
            _isEditMode
                ? 'Paciente atualizado com sucesso!'
                : 'Paciente cadastrado com sucesso!');
        _nameController.clear();
        Modular.to.pop();
      },
      (failure) {
        Alerts.showFailure(context, failure.message);
      },
    );
  }

  void _savePatient() {
    if (_formKey.currentState!.validate()) {
      final newPatient = PatientEntity(
        id: _isEditMode ? patient!.id : '',
        name: _nameController.text.trim(),
      );

      viewModel.savePatientCommand.execute(newPatient);
    }
  }

  @override
  void dispose() {
    viewModel.savePatientCommand.removeListener(_savePatientListener);
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Editar Paciente' : 'Cadastrar Paciente'),
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Paciente',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o nome do paciente';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ListenableBuilder(
              listenable: viewModel.savePatientCommand,
              builder: (context, child) {
                return PrimaryButtonDs(
                  isLoading: viewModel.savePatientCommand.running,
                  onPressed: _savePatient,
                  title:
                      _isEditMode ? 'Salvar Alterações' : 'Cadastrar Paciente',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
