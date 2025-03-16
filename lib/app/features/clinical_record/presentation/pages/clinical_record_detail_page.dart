import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/features/clinical_record/domain/entities/clinical_record_entity.dart';
import 'package:flutter_therapy_evolution/app/features/clinical_record/presentation/viewmodels/clinical_record_viewmodel.dart';

import '../../../../core/command/command_stream_listenable_builder.dart';

class PatientClinicalRecordDetailPage extends StatefulWidget {
  final String clinicalRecordId;

  const PatientClinicalRecordDetailPage(
      {super.key, required this.clinicalRecordId});

  @override
  State<PatientClinicalRecordDetailPage> createState() =>
      _PatientClinicalRecordDetailPageState();
}

class _PatientClinicalRecordDetailPageState
    extends State<PatientClinicalRecordDetailPage> {
  final viewModel = Modular.get<ClinicalRecordViewmodel>();

  @override
  void initState() {
    super.initState();
    viewModel.clinicalRecordStream.execute(widget.clinicalRecordId);
  }

  @override
  void dispose() {
    viewModel.clinicalRecordStream.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
        centerTitle: true,
      ),
      body: CommandStreamListenableBuilder<ClinicalRecordEntity>(
        stream: viewModel.clinicalRecordStream,
        builder: (context, value) {
          final ClinicalRecordEntity clinicalRecord = value;
          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    clinicalRecord.date,
                    style: theme.textTheme.titleLarge,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (clinicalRecord.chiefComplaint != null)
                        Text(
                            'Queixa Principal do: ${clinicalRecord.chiefComplaint}'),
                      if (clinicalRecord.presentIllness != null)
                        Text('Doença Atual: ${clinicalRecord.presentIllness}'),
                      if (clinicalRecord.diagnosis != null)
                        Text('Diagnóstico: ${clinicalRecord.diagnosis}'),
                      const SizedBox(height: 8),
                      Text(
                          'Criado em: ${clinicalRecord.createdAt?.toLocal().toString().split(' ')[0]}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                      Text(
                          'Atualizado em: ${clinicalRecord.updatedAt?.toLocal().toString().split(' ')[0]}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
