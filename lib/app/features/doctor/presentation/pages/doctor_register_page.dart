import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/widgets/result_handler.dart';

import '../viewmodels/doctor_viewmodel.dart';
import '../../domain/entities/doctor_entity.dart';

class DoctorRegisterPage extends StatefulWidget {
  final DoctorEntity? doctor;

  const DoctorRegisterPage({
    super.key,
    this.doctor,
  });

  @override
  State<DoctorRegisterPage> createState() => _DoctorRegisterPageState();
}

class _DoctorRegisterPageState extends State<DoctorRegisterPage> {
  final viewModel = Modular.get<DoctorViewmodel>();
  DoctorEntity? get doctor => widget.doctor;
  bool _isEditMode = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel.saveDoctorCommand.addListener(_saveDoctorListener);

    _isEditMode = widget.doctor != null;

    if (_isEditMode) {
      _loadDoctor();
    }
  }

  void _loadDoctor() {
    _nameController.text = doctor!.name;
  }

  void _saveDoctorListener() {
    ResultHandler.showAlert(
      context: context,
      result: viewModel.saveDoctorCommand.result,
      successMessage:
          _isEditMode ? 'Atualizado com sucesso!' : 'Cadastrado com sucesso!',
      onSuccess: (value) {
        Modular.to.pop();
      },
    );
  }

  void _saveDoctor() {
    if (_formKey.currentState!.validate()) {
      final newDoctor = DoctorEntity(
        id: _isEditMode ? doctor!.id : '',
        name: _nameController.text,
      );

      viewModel.saveDoctorCommand.execute(newDoctor);
    }
  }

  @override
  void dispose() {
    viewModel.saveDoctorCommand.removeListener(_saveDoctorListener);
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
              isLoading: viewModel.saveDoctorCommand.running,
              onPressed: _saveDoctor,
              title: _isEditMode ? 'Salvar Alterações' : 'Cadastrar',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
