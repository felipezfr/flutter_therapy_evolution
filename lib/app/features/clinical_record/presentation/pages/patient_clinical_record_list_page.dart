import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/widgets/delete_dialog.dart';
import 'package:flutter_therapy_evolution/app/core/widgets/result_handler.dart';
import 'package:flutter_therapy_evolution/app/features/patient/domain/entities/patient_entity.dart';
import '../../../../core/command/command_stream_listenable_builder.dart';
import '../../domain/entities/clinical_record_entity.dart';
import '../viewmodels/clinical_record_viewmodel.dart';

class PatientClinicalRecordListPage extends StatefulWidget {
  final String patientId;
  const PatientClinicalRecordListPage({
    super.key,
    required this.patientId,
  });

  @override
  State<PatientClinicalRecordListPage> createState() =>
      _PatientClinicalRecordListPageState();
}

class _PatientClinicalRecordListPageState
    extends State<PatientClinicalRecordListPage> {
  final viewModel = Modular.get<ClinicalRecordViewmodel>();

  PatientEntity? patient;

  @override
  void initState() {
    super.initState();
    viewModel.patientStreamCommand.execute(widget.patientId);
    viewModel.clinicalRecordStream.execute(widget.patientId);
    viewModel.deleteClinicalRecordCommand.addListener(_onDeleteClinicalRecord);
  }

  @override
  void dispose() {
    viewModel.patientStreamCommand.dispose();
    viewModel.clinicalRecordStream.dispose();
    viewModel.deleteClinicalRecordCommand
        .removeListener(_onDeleteClinicalRecord);
    super.dispose();
  }

  void _onDeleteClinicalRecord() {
    ResultHandler.showAlert(
      context: context,
      result: viewModel.deleteClinicalRecordCommand.result,
      successMessage: 'Evolução excluída com sucesso!',
    );
  }

  void _confirmDeleteClinicalRecord(
      ClinicalRecordEntity clinicalRecord, PatientEntity patient) {
    DeleteDialog.showDeleteConfirmation(
      context: context,
      entityName:
          'a evolução de ${patient.name} do dia ${clinicalRecord.date}?',
      onConfirm: () {
        viewModel.deleteClinicalRecordCommand.execute(clinicalRecord.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evoluções do paciente'),
      ),
      body: CommandStreamListenableBuilder<PatientEntity>(
        stream: viewModel.patientStreamCommand,
        emptyMessage: 'Paciente não encontrado',
        emptyIconData: Icons.error,
        emptyHowRegisterMessage: '',
        builder: (context, patientValue) {
          patient = patientValue;
          return CommandStreamListenableBuilder<List<ClinicalRecordEntity>>(
            stream: viewModel.clinicalRecordStream,
            emptyMessage: 'Nenhum evolução cadastrada',
            emptyIconData: Icons.app_registration_rounded,
            builder: (context, clinicalRecord) {
              return _buildPatientRecordList(clinicalRecord, patientValue);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToRegisterPage(patient),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPatientRecordList(
      List<ClinicalRecordEntity> patientClinicalRecords,
      PatientEntity patient) {
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
                      'Queixa Principal do: ${patientClinicalRecord.chiefComplaint}'),
                if (patientClinicalRecord.presentIllness != null)
                  Text('Doença Atual: ${patientClinicalRecord.presentIllness}'),
                if (patientClinicalRecord.diagnosis != null)
                  Text('Diagnóstico: ${patientClinicalRecord.diagnosis}'),
                const SizedBox(height: 8),
                Text(
                    'Criado em: ${patientClinicalRecord.createdAt?.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(
                    'Atualizado em: ${patientClinicalRecord.updatedAt?.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () =>
                      _navigateToEditPage(patientClinicalRecord, patient),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDeleteClinicalRecord(
                      patientClinicalRecord, patient),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToRegisterPage(PatientEntity? patient) {
    Modular.to.pushNamed('../register', arguments: {
      'patientEntity': patient,
    });
  }

  void _navigateToEditPage(
      ClinicalRecordEntity clinicalRecord, PatientEntity patient) {
    Modular.to.pushNamed(
      '../edit',
      arguments: {
        'patientEntity': patient,
        'clinicalRecordEntity': clinicalRecord
      },
    );
  }
}
