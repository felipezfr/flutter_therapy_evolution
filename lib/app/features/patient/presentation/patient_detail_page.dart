import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/features/patient/domain/entities/patient_entity.dart';

import 'patient_viewmodel.dart';

class PatientDetailPage extends StatefulWidget {
  final PatientEntity patient;

  const PatientDetailPage({super.key, required this.patient});

  @override
  State<PatientDetailPage> createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage> {
  final viewModel = Modular.get<PatientViewmodel>();

  PatientEntity get patient => widget.patient;

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
        child: Column(
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
              onPressed: () {
                Modular.to.pushNamed(
                  '/clinical_record/patient',
                  arguments: {
                    'patientEntity': patient,
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            PrimaryButtonDs(
              title: 'Agendamentos',
              onPressed: () {
                Modular.to.pushNamed(
                  '/appointment/patient',
                  arguments: {
                    'patientEntity': patient,
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
