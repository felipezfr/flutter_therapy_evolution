import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/session/logged_user.dart';
import 'package:intl/intl.dart';
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
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _documentIdController = TextEditingController();
  final _notesController = TextEditingController();

  // Address controllers
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementController = TextEditingController();
  final _districtController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();

  // Insurance controllers
  final _insuranceProviderController = TextEditingController();
  final _insuranceNumberController = TextEditingController();

  DateTime _birthDate = DateTime.now();
  String _gender = 'Male';
  String _status = 'active';

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
    final patient = widget.patient!;
    _nameController.text = patient.name;
    _emailController.text = patient.email;
    _phoneController.text = patient.phone;
    _documentIdController.text = patient.documentId;
    _birthDate = patient.birthDate;
    _gender = patient.gender;
    _notesController.text = patient.notes ?? '';
    _status = patient.status;

    // Address
    _streetController.text = patient.address.street;
    _numberController.text = patient.address.number;
    _complementController.text = patient.address.complement ?? '';
    _districtController.text = patient.address.district;
    _cityController.text = patient.address.city;
    _stateController.text = patient.address.state;
    _zipCodeController.text = patient.address.zipCode;

    // Insurance
    _insuranceProviderController.text = patient.insuranceProvider ?? '';
    _insuranceNumberController.text = patient.insuranceNumber ?? '';
  }

  void _savePatientListener() {
    viewModel.savePatientCommand.result?.fold(
      (success) {
        Alerts.showSuccess(
            context,
            _isEditMode
                ? 'Paciente atualizado com sucesso!'
                : 'Paciente cadastrado com sucesso!');
        _clearForm();
        Modular.to.pop();
      },
      (failure) {
        Alerts.showFailure(context, failure.message);
      },
    );
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _documentIdController.clear();
    _notesController.clear();
    _streetController.clear();
    _numberController.clear();
    _complementController.clear();
    _districtController.clear();
    _cityController.clear();
    _stateController.clear();
    _zipCodeController.clear();
    _insuranceProviderController.clear();
    _insuranceNumberController.clear();
    setState(() {
      _birthDate = DateTime.now();
      _gender = 'Male';
      _status = 'active';
    });
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  void _savePatient() {
    if (_formKey.currentState!.validate()) {
      final address = PatientAddress(
        street: _streetController.text.trim(),
        number: _numberController.text.trim(),
        complement: _complementController.text.trim().isEmpty
            ? null
            : _complementController.text.trim(),
        district: _districtController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        zipCode: _zipCodeController.text.trim(),
      );

      final newPatient = PatientEntity(
        id: _isEditMode ? patient!.id : '',
        name: _nameController.text.trim(),
        birthDate: _birthDate,
        gender: _gender,
        documentId: _documentIdController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: address,
        insuranceProvider: _insuranceProviderController.text.trim().isEmpty
            ? null
            : _insuranceProviderController.text.trim(),
        insuranceNumber: _insuranceNumberController.text.trim().isEmpty
            ? null
            : _insuranceNumberController.text.trim(),
        responsibleProfessional: LoggedUser.id,
        registrationDate:
            _isEditMode ? patient!.registrationDate : DateTime.now(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        status: _status,
      );

      viewModel.savePatientCommand.execute(newPatient);
    }
  }

  @override
  void dispose() {
    viewModel.savePatientCommand.removeListener(_savePatientListener);
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _documentIdController.dispose();
    _notesController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    _districtController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _insuranceProviderController.dispose();
    _insuranceNumberController.dispose();
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Personal Information Section
            const Text(
              'Informações Pessoais',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

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
            const SizedBox(height: 16),

            // Birth Date
            InkWell(
              onTap: () => _selectBirthDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Data de Nascimento',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  DateFormat('dd/MM/yyyy').format(_birthDate),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Gender
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Gênero',
                border: OutlineInputBorder(),
              ),
              value: _gender,
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Masculino')),
                DropdownMenuItem(value: 'Female', child: Text('Feminino')),
                DropdownMenuItem(value: 'Other', child: Text('Outro')),
              ],
              onChanged: (value) {
                setState(() {
                  _gender = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _documentIdController,
              decoration: const InputDecoration(
                labelText: 'CPF',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o CPF do paciente';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o e-mail do paciente';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Telefone',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o telefone do paciente';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Address Section
            const Text(
              'Endereço',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _streetController,
              decoration: const InputDecoration(
                labelText: 'Rua',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira a rua';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _numberController,
                    decoration: const InputDecoration(
                      labelText: 'Número',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insira o número';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _complementController,
                    decoration: const InputDecoration(
                      labelText: 'Complemento',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _districtController,
              decoration: const InputDecoration(
                labelText: 'Bairro',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o bairro';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'Cidade',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insira a cidade';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _stateController,
                    decoration: const InputDecoration(
                      labelText: 'Estado',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insira o estado';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _zipCodeController,
              decoration: const InputDecoration(
                labelText: 'CEP',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o CEP';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Insurance Section
            const Text(
              'Plano de Saúde (Opcional)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _insuranceProviderController,
              decoration: const InputDecoration(
                labelText: 'Convênio',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _insuranceNumberController,
              decoration: const InputDecoration(
                labelText: 'Número da Carteirinha',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Additional Information
            const Text(
              'Informações Adicionais',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Status
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              value: _status,
              items: const [
                DropdownMenuItem(value: 'active', child: Text('Ativo')),
                DropdownMenuItem(value: 'inactive', child: Text('Inativo')),
              ],
              onChanged: (value) {
                setState(() {
                  _status = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Observações',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

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
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
