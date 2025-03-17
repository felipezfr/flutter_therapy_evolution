import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/widgets/result_handler.dart';
import '../../../../core/command/command_stream_listenable_builder.dart';
import '../../../../core/widgets/delete_dialog.dart';
import '../viewmodels/consultation_viewmodel.dart';

import '../../domain/entities/consultation_entity.dart';

class ConsultationListPage extends StatefulWidget {
  const ConsultationListPage({super.key});

  @override
  State<ConsultationListPage> createState() => _ConsultationListPageState();
}

class _ConsultationListPageState extends State<ConsultationListPage> {
  final viewModel = Modular.get<ConsultationViewmodel>();

  @override
  void initState() {
    super.initState();
    viewModel.consultationsStreamCommand.execute();
    viewModel.deleteConsultationCommand.addListener(_onDeleteConsultation);
  }

  @override
  void dispose() {
    viewModel.deleteConsultationCommand.removeListener(_onDeleteConsultation);
    viewModel.consultationsStreamCommand.dispose();
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
        title: const Text('Todas Consultas'),
      ),
      body: CommandStreamListenableBuilder<List<ConsultationEntity>>(
        stream: viewModel.consultationsStreamCommand,
        emptyMessage: 'Nenhuma consulta cadastrada',
        emptyIconData: Icons.app_registration_rounded,
        builder: (context, value) {
          return _buildConsultationList(value);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToRegisterPage,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildConsultationList(List<ConsultationEntity> consultations) {
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

  void _navigateToEditPage(
    ConsultationEntity consultation,
  ) {
    Modular.to.pushNamed('./edit', arguments: {
      'consultationEntity': consultation,
    });
  }

  void _navigateToDetailPage(ConsultationEntity consultation) {
    Modular.to.pushNamed('./detail/${consultation.id}');
  }

  void _navigateToRegisterPage() {
    Modular.to.pushNamed('./register');
  }
}
