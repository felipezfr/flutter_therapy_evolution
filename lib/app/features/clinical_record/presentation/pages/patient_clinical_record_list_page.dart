import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/utils/date_time_utils.dart';
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

  PatientEntity? _patient;

  @override
  void initState() {
    super.initState();
    viewModel.patientStreamCommand.execute(widget.patientId);
    viewModel.clinicalRecordsPatientStream.execute(widget.patientId);
    viewModel.deleteClinicalRecordCommand.addListener(_onDeleteClinicalRecord);
  }

  @override
  void dispose() {
    viewModel.patientStreamCommand.dispose();
    viewModel.clinicalRecordsPatientStream.dispose();
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
          'a evolução de ${patient.name} do dia ${DateTimeUtils.formateDate(clinicalRecord.date)}?',
      onConfirm: () {
        viewModel.deleteClinicalRecordCommand.execute(clinicalRecord.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            _patient?.name != null ? 'Evoluções de ${_patient?.name}' : ''),
      ),
      body: CommandStreamListenableBuilder<PatientEntity>(
        stream: viewModel.patientStreamCommand,
        emptyMessage: 'Paciente não encontrado',
        emptyIconData: Icons.error,
        emptyHowRegisterMessage: '',
        builder: (context, patientValue) {
          _patient = patientValue;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {});
            }
          });
          return CommandStreamListenableBuilder<List<ClinicalRecordEntity>>(
            stream: viewModel.clinicalRecordsPatientStream,
            emptyMessage: 'Nenhum evolução cadastrada',
            emptyIconData: Icons.app_registration_rounded,
            builder: (context, clinicalRecord) {
              return _buildPatientRecordList(clinicalRecord, patientValue);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToRegisterPage(_patient),
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

        return CustomCard(
          title:
              '${DateTimeUtils.formateDate(patientClinicalRecord.date)} - ${DateTimeUtils.dayOfTheWeekName(patientClinicalRecord.date)}',
          children: [
            CardTile(
              title: 'Queixa Principal:',
              text: '${patientClinicalRecord.chiefComplaint}',
            ),
            CardTile(
              title: 'Doença Atual:',
              text: '${patientClinicalRecord.presentIllness}',
            ),
            CardTile(
              title: 'Diagnóstico:',
              text: '${patientClinicalRecord.diagnosis}',
            ),
            CardTile(
              title: 'Exame Fisico:',
              text: '${patientClinicalRecord.physicalExam}',
            ),
            CardTile(
              title: 'Recomentações:',
              text: '${patientClinicalRecord.recommendations}',
            ),
          ],
          onTap: () {
            _navigateToDetailPage(patientClinicalRecord.id, patient.id);
          },
          onTapEdit: () {
            _navigateToEditPage(patientClinicalRecord, patient);
          },
          onTapDelete: () {
            _confirmDeleteClinicalRecord(patientClinicalRecord, patient);
          },
        );
      },
    );
  }

  void _navigateToDetailPage(String clinicalRecordId, String patientId) {
    Modular.to.pushNamed('../detail', arguments: {
      'clinicalRecordId': clinicalRecordId,
      'patientId': patientId,
    });
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
