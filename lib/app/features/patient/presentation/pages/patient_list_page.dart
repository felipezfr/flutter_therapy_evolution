import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/widgets/result_handler.dart';
import '../../../../core/command/command_stream_listenable_builder.dart';
import '../../../../core/widgets/delete_dialog.dart';
import '../viewmodels/patient_viewmodel.dart';

import '../../domain/entities/patient_entity.dart';

class PatientListPage extends StatefulWidget {
  const PatientListPage({super.key});

  @override
  State<PatientListPage> createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  final viewModel = Modular.get<PatientViewmodel>();
  final TextEditingController _searchController = TextEditingController();
  List<PatientEntity> _filteredPatients = [];
  List<PatientEntity> _allPatients = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    viewModel.deletePatientCommand.addListener(_onDeletePatient);
  }

  @override
  void dispose() {
    viewModel.deletePatientCommand.removeListener(_onDeletePatient);
    viewModel.patientsStreamCommand.dispose();
    _searchController.dispose();
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
    Modular.to.pushNamed('./detail/${patient.id}');
  }

  void _navigateToRegisterPage() {
    Modular.to.pushNamed('./register');
  }

  int? _calculateAge(DateTime? birthDate) {
    if (birthDate == null) return null;
    int age = DateTime.now().year - birthDate.year;
    if (DateTime.now().month < birthDate.month ||
        (DateTime.now().month == birthDate.month &&
            DateTime.now().day < birthDate.day)) {
      age--; // Subtrai 1 se o aniversário ainda não ocorreu este ano
    }
    return age;
  }

  void _filterPatients(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredPatients = _allPatients;
        _isSearching = false;
      });
      return;
    }

    final searchTerms = query.toLowerCase().split(' ');

    setState(() {
      _filteredPatients = _allPatients.where((patient) {
        final String searchFields = [
          patient.name.toLowerCase(),
          patient.email.toLowerCase(),
          patient.phone.toLowerCase(),
          patient.address.city.toLowerCase(),
          patient.address.state.toLowerCase(),
        ].join(' ');

        return searchTerms.every((term) => searchFields.contains(term));
      }).toList();
      _isSearching = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Pacientes',
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: CommandStreamListenableBuilder<List<PatientEntity>>(
              stream: viewModel.patientsStreamCommand,
              emptyMessage: 'Nenhum paciente cadastrado',
              emptyIconData: Icons.person_add_alt_1_rounded,
              builder: (context, patients) {
                _allPatients = patients;
                if (!_isSearching) {
                  _filteredPatients = patients;
                }
                return _buildPatientList(_filteredPatients);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToRegisterPage,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Pesquisar pacientes...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterPatients('');
                    FocusScope.of(context).unfocus();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        onChanged: _filterPatients,
      ),
    );
  }

  Widget _buildPatientList(List<PatientEntity> patients) {
    if (patients.isEmpty && _isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum paciente encontrado para "${_searchController.text}"',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: patients.length,
      itemBuilder: (context, index) {
        final patient = patients[index];

        return CustomCard(
          title: patient.name,
          titleIcon: true,
          children: [
            CardTile(
              title: 'Idade:',
              text: '${_calculateAge(patient.birthDate) ?? '-'}',
            ),
            CardTile(
              title: 'Cidade:',
              text: '${patient.address.city}, ${patient.address.state}',
            ),
          ],
          onTapEdit: () {
            _navigateToEditPage(patient);
          },
          onTapDelete: () {
            _confirmDeletePatient(patient);
          },
          onTap: () {
            _navigateToDetailPage(patient);
          },
        );
      },
    );
  }
}
