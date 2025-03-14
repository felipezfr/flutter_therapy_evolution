import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/features/patient/domain/entities/patient_entity.dart';
import '../../../core/alert/alerts.dart';
import '../../../core/command/command_stream_listenable_builder.dart';
import '../domain/entities/clinical_record_entity.dart';
import 'clinical_record_viewmodel.dart';

class PatientClinicalRecordPage extends StatefulWidget {
  final PatientEntity patient;
  const PatientClinicalRecordPage({
    super.key,
    required this.patient,
  });

  @override
  State<PatientClinicalRecordPage> createState() =>
      _PatientClinicalRecordPageState();
}

class _PatientClinicalRecordPageState extends State<PatientClinicalRecordPage> {
  final viewModel = Modular.get<ClinicalRecordViewmodel>();

  PatientEntity get patient => widget.patient;

  @override
  void initState() {
    super.initState();
    viewModel.patientClinicalRecordStream.execute(patient.id);
    viewModel.deletePatientClinicalRecordCommand
        .addListener(_onDeleteClinicalRecord);
  }

  @override
  void dispose() {
    viewModel.patientClinicalRecordStream.dispose();
    viewModel.deletePatientClinicalRecordCommand
        .removeListener(_onDeleteClinicalRecord);
    super.dispose();
  }

  void _onDeleteClinicalRecord() {
    viewModel.deletePatientClinicalRecordCommand.result?.fold(
      (success) {
        Alerts.showSuccess(context, 'Evolução excluída com sucesso!');
      },
      (failure) {
        Alerts.showFailure(context, failure.message);
      },
    );
  }

  void _confirmDeleteClinicalRecord(ClinicalRecordEntity clinicalRecord) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Excluir Evolução',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Text(
          'Deseja realmente excluir a evolução de ${patient.name} do dia ${clinicalRecord.date}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              viewModel.deletePatientClinicalRecordCommand
                  .execute(clinicalRecord.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _navigateToRegisterPage() {
    Modular.to.pushNamed('./register', arguments: {
      'patientEntity': patient,
    });
  }

  void _navigateToEditPage(ClinicalRecordEntity clinicalRecord) {
    Modular.to.pushNamed(
      './edit',
      arguments: {
        'patientEntity': patient,
        'clinicalRecordEntity': clinicalRecord
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evoluções do paciente'),
      ),
      body: CommandStreamListenableBuilder<List<ClinicalRecordEntity>>(
        stream: viewModel.patientClinicalRecordStream,
        emptyMessage: 'Nenhum evolução cadastrada',
        emptyIconData: Icons.app_registration_rounded,
        builder: (context, value) {
          return _buildPatientRecordList(value);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToRegisterPage,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPatientRecordList(
      List<ClinicalRecordEntity> patientClinicalRecords) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: patientClinicalRecords.length,
      itemBuilder: (context, index) {
        final patientClinicalRecord = patientClinicalRecords[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              patientClinicalRecord.date,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (patientClinicalRecord.chiefComplaint != null)
                  Text(
                      'Queixa Principal: ${patientClinicalRecord.chiefComplaint}'),
                if (patientClinicalRecord.presentIllness != null)
                  Text('Doença Atual: ${patientClinicalRecord.presentIllness}'),
                if (patientClinicalRecord.diagnosis != null)
                  Text('Diagnóstico: ${patientClinicalRecord.diagnosis}'),
                const SizedBox(height: 8),
                Text(
                    'Criado em: ${patientClinicalRecord.createdAt.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(
                    'Atualizado em: ${patientClinicalRecord.updatedAt.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _navigateToEditPage(patientClinicalRecord),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      _confirmDeleteClinicalRecord(patientClinicalRecord),
                ),
              ],
            ),
            onTap: () => _navigateToEditPage(patientClinicalRecord),
          ),
        );
      },
    );
  }
}
