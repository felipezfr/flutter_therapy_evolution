import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/widgets/result_handler.dart';
import 'package:flutter_therapy_evolution/app/features/patient/domain/entities/patient_entity.dart';
import '../../../../core/command/command_stream_listenable_builder.dart';
import '../../../../core/widgets/delete_dialog.dart';
import '../viewmodels/consultation_viewmodel.dart';

import '../../domain/entities/consultation_entity.dart';

class PatientConsultationListPage extends StatefulWidget {
  final String patientId;
  const PatientConsultationListPage({super.key, required this.patientId});

  @override
  State<PatientConsultationListPage> createState() =>
      _PatientConsultationListPageState();
}

class _PatientConsultationListPageState
    extends State<PatientConsultationListPage> {
  final viewModel = Modular.get<ConsultationViewmodel>();

  PatientEntity? patient;

  @override
  void initState() {
    super.initState();
    viewModel.patientStreamCommand.execute(widget.patientId);
    viewModel.patientConsultationsStreamCommand.execute(widget.patientId);
    viewModel.deleteConsultationCommand.addListener(_onDeleteConsultation);
  }

  @override
  void dispose() {
    viewModel.patientStreamCommand.dispose();
    viewModel.patientConsultationsStreamCommand.dispose();
    viewModel.deleteConsultationCommand.removeListener(_onDeleteConsultation);
    super.dispose();
  }

  void _onDeleteConsultation() {
    ResultHandler.showAlert(
      context: context,
      result: viewModel.deleteConsultationCommand.result,
      successMessage: 'Excluído com sucesso!',
    );
  }

  void _confirmDeleteConsultation(ConsultationEntity consultation) {
    DeleteDialog.showDeleteConfirmation(
      context: context,
      title: 'Excluir',
      entityName: consultation.name,
      onConfirm: () {
        viewModel.deleteConsultationCommand.execute(consultation.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultas de ${widget.patientId}'),
      ),
      body: CommandStreamListenableBuilder<PatientEntity>(
          stream: viewModel.patientStreamCommand,
          builder: (context, patientValue) {
            patient = patientValue;
            return CommandStreamListenableBuilder<List<ConsultationEntity>>(
              stream: viewModel.patientConsultationsStreamCommand,
              emptyMessage: 'Nenhuma consulta cadastrada',
              emptyIconData: Icons.app_registration_rounded,
              builder: (context, value) {
                return _buildConsultationList(value, patientValue);
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToRegisterPage(patient!),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildConsultationList(
      List<ConsultationEntity> consultations, PatientEntity patient) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: consultations.length,
      itemBuilder: (context, index) {
        final consultation = consultations[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                consultation.name.isNotEmpty
                    ? consultation.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              consultation.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text('ID: ${consultation.id}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _navigateToEditPage(consultation),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDeleteConsultation(consultation),
                ),
              ],
            ),
            onTap: () => _navigateToDetailPage(consultation),
          ),
        );
      },
    );
  }

  void _navigateToEditPage(ConsultationEntity consultation) {
    Modular.to.pushNamed('../edit', arguments: {
      'consultationEntity': consultation,
    });
  }

  void _navigateToDetailPage(ConsultationEntity consultation) {
    Modular.to.pushNamed('../detail/${consultation.id}');
  }

  void _navigateToRegisterPage(PatientEntity patient) {
    Modular.to.pushNamed(
      '../register',
      arguments: {'patientEntity': patient},
    );
  }
}
