import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/command/command_stream_listenable_builder.dart';
import 'package:flutter_therapy_evolution/app/features/patient/domain/entities/patient_entity.dart';

import '../viewmodels/patient_viewmodel.dart';

class PatientDetailPage extends StatefulWidget {
  final String patientId;

  const PatientDetailPage({super.key, required this.patientId});

  @override
  State<PatientDetailPage> createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage> {
  final viewModel = Modular.get<PatientViewmodel>();

  @override
  void initState() {
    super.initState();
    viewModel.patientStreamCommand.execute(widget.patientId);
  }

  @override
  void dispose() {
    viewModel.patientStreamCommand.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Paciente'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: size.width,
        child: CommandStreamListenableBuilder<PatientEntity>(
          stream: viewModel.patientStreamCommand,
          builder: (context, value) {
            final PatientEntity patient = value;
            return Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      patient.name,
                      style: theme.textTheme.titleLarge,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Telefone: ${patient.phone}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          'Email: ${patient.email}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          'Gênero: ${patient.gender}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          'Data de Nascimento: ${patient.birthDate.toLocal().toString().split(' ')[0]}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          'Endereço: ${patient.address.street}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButtonDs(
                  title: 'Evoluções',
                  onPressed: () => _navigateToClinicalRecord(patient),
                ),
                const SizedBox(height: 20),
                PrimaryButtonDs(
                  title: 'Agendamentos',
                  onPressed: () => _navigateAppointment(patient),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _navigateAppointment(PatientEntity patient) {
    Modular.to.pushNamed('/appointment/patient/${patient.id}');
  }

  void _navigateToClinicalRecord(PatientEntity patient) {
    Modular.to.pushNamed('/clinical_record/patient/${patient.id}');
  }
}
