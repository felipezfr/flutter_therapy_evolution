import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/features/patient/presentation/widgets/error_state_widget.dart';
import 'patient_viewmodel.dart';

import '../../../core/alert/alerts.dart';
import '../domain/entities/patient_entity.dart';
import 'widgets/empty_state_widget.dart';

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

  void _onDeletePatient() {
    viewModel.deletePatientCommand.result?.fold(
      (success) {
        Alerts.showSuccess(context, 'Paciente excluído com sucesso!');
      },
      (failure) {
        Alerts.showFailure(context, failure.message);
      },
    );
  }

  @override
  void dispose() {
    viewModel.deletePatientCommand.removeListener(_onDeletePatient);
    viewModel.patientsStreamCommand.dispose();
    super.dispose();
  }

  void _confirmDeletePatient(PatientEntity patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Excluir Paciente',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Text(
          'Deseja realmente excluir o paciente ${patient.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              viewModel.deletePatientCommand.execute(patient.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _navigateToEditPage(PatientEntity patient) {
    Modular.to.pushNamed('./edit', arguments: {
      'patientEntity': patient,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
      ),
      body: ListenableBuilder(
        listenable: viewModel.patientsStreamCommand,
        builder: (context, _) {
          if (viewModel.patientsStreamCommand.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final result = viewModel.patientsStreamCommand.result;

          if (result == null) {
            return EmptyStateWidget();
          }

          return result.fold(
            (patients) {
              if (patients.isEmpty) {
                return EmptyStateWidget();
              }
              return _buildPatientList(patients);
            },
            (error) {
              return ErrorStateWidget(
                message: error.message,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Modular.to.pushNamed('./register'),
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
            onTap: () => _navigateToEditPage(patient),
          ),
        );
      },
    );
  }
}
