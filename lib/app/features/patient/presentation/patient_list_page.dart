import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/widgets/result_handler.dart';
import '../../../core/command/command_stream_listenable_builder.dart';
import '../../../core/widgets/delete_dialog.dart';
import 'patient_viewmodel.dart';

import '../domain/entities/patient_entity.dart';

class PatientListPage extends StatefulWidget {
  const PatientListPage({super.key});

  @override
  State<PatientListPage> createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  final viewModel = Modular.get<PatientViewmodel>();

  @override
  void initState() {
    super.initState();
    viewModel.deletePatientCommand.addListener(_onDeletePatient);
  }

  @override
  void dispose() {
    viewModel.deletePatientCommand.removeListener(_onDeletePatient);
    viewModel.patientsStreamCommand.dispose();
    super.dispose();
  }

  void _onDeletePatient() {
    ResultHandler.showAlert(
      context: context,
      result: viewModel.deletePatientCommand.result,
      successMessage: 'Paciente excluído com sucesso!',
    );
  }

  void _confirmDeletePatient(PatientEntity patient) {
    DeleteDialog.showDeleteConfirmation(
      context: context,
      title: 'Excluir Paciente',
      entityName: 'o paciente ${patient.name}',
      onConfirm: () {
        viewModel.deletePatientCommand.execute(patient.id);
      },
    );
  }

  void _navigateToEditPage(PatientEntity patient) {
    Modular.to.pushNamed('./edit', arguments: {
      'patientEntity': patient,
    });
  }

  void _navigateToDetailPage(PatientEntity patient) {
    Modular.to.pushNamed('./detail', arguments: {
      'patientEntity': patient,
    });
  }

  void _navigateToRegisterPage() {
    Modular.to.pushNamed('./register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
      ),
      body: CommandStreamListenableBuilder<List<PatientEntity>>(
        stream: viewModel.patientsStreamCommand,
        emptyMessage: 'Nenhum evolução cadastrada',
        emptyIconData: Icons.app_registration_rounded,
        builder: (context, value) {
          return _buildPatientList(value);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToRegisterPage,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPatientList(List<PatientEntity> patients) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: patients.length,
      itemBuilder: (context, index) {
        final patient = patients[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                patient.name.isNotEmpty ? patient.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              patient.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text('ID: ${patient.id}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _navigateToEditPage(patient),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDeletePatient(patient),
                ),
              ],
            ),
            onTap: () => _navigateToDetailPage(patient),
          ),
        );
      },
    );
  }
}
