import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/widgets/result_handler.dart';
import '../../../../core/command/command_stream_listenable_builder.dart';
import '../../../../core/widgets/delete_dialog.dart';
import '../viewmodels/doctor_viewmodel.dart';

import '../../domain/entities/doctor_entity.dart';

class DoctorListPage extends StatefulWidget {
  const DoctorListPage({super.key});

  @override
  State<DoctorListPage> createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  final viewModel = Modular.get<DoctorViewmodel>();

  @override
  void initState() {
    super.initState();
    viewModel.deleteDoctorCommand.addListener(_onDeleteDoctor);
  }

  @override
  void dispose() {
    viewModel.deleteDoctorCommand.removeListener(_onDeleteDoctor);
    viewModel.doctorsStreamCommand.dispose();
    super.dispose();
  }

  void _onDeleteDoctor() {
    ResultHandler.showAlert(
      context: context,
      result: viewModel.deleteDoctorCommand.result,
      successMessage: 'Excluído com sucesso!',
    );
  }

  void _confirmDeleteDoctor(DoctorEntity doctor) {
    DeleteDialog.showDeleteConfirmation(
      context: context,
      title: 'Excluir',
      entityName: doctor.name,
      onConfirm: () {
        viewModel.deleteDoctorCommand.execute(doctor.id);
      },
    );
  }

  void _navigateToEditPage(DoctorEntity doctor) {
    Modular.to.pushNamed('./edit', arguments: {
      'doctorEntity': doctor,
    });
  }

  void _navigateToDetailPage(DoctorEntity doctor) {
    Modular.to.pushNamed('./detail', arguments: {
      'doctorEntity': doctor,
    });
  }

  void _navigateToRegisterPage() {
    Modular.to.pushNamed('./register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor'),
      ),
      body: CommandStreamListenableBuilder<List<DoctorEntity>>(
        stream: viewModel.doctorsStreamCommand,
        emptyMessage: 'Nenhum dado cadastrado',
        emptyIconData: Icons.app_registration_rounded,
        builder: (context, value) {
          return _buildDoctorList(value);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToRegisterPage,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDoctorList(List<DoctorEntity> doctors) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                doctor.name.isNotEmpty ? doctor.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              doctor.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text('ID: ${doctor.id}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _navigateToEditPage(doctor),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDeleteDoctor(doctor),
                ),
              ],
            ),
            onTap: () => _navigateToDetailPage(doctor),
          ),
        );
      },
    );
  }
}
