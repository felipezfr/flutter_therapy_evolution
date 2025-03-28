import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/command/command_stream_listenable_builder.dart';
import 'package:flutter_therapy_evolution/app/core/utils/date_time_utils.dart';
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
    // final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Paciente'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: CommandStreamListenableBuilder<PatientEntity>(
            stream: viewModel.patientStreamCommand,
            builder: (context, value) {
              final PatientEntity patient = value;
              return Column(
                children: [
                  CustomCard(
                    title: patient.name,
                    children: [
                      CardTile(title: 'Telefone: ', text: patient.phone),
                      CardTile(title: 'Email: ', text: patient.email),
                      CardTile(title: 'Gênero: ', text: patient.gender),
                      CardTile(
                          title: 'Data de Nascimento: ',
                          text: DateTimeUtils.formateDate(patient.birthDate)),
                      CardTile(
                        title: 'Endereço: ',
                        text:
                            '${patient.address.street}, ${patient.address.city}, ${patient.address.state}, ${patient.address.number}, ${patient.address.district}, ${patient.address.zipCode}, ${patient.address.complement}',
                      ),
                    ],
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
