import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/features/consultation/domain/entities/consultation_entity.dart';

import '../../../../core/command/command_stream_listenable_builder.dart';
import '../viewmodels/consultation_viewmodel.dart';

class ConsultationDetailPage extends StatefulWidget {
  final String consultationId;

  const ConsultationDetailPage({super.key, required this.consultationId});

  @override
  State<ConsultationDetailPage> createState() => _ConsultationDetailPageState();
}

class _ConsultationDetailPageState extends State<ConsultationDetailPage> {
  final viewModel = Modular.get<ConsultationViewmodel>();

  @override
  void initState() {
    super.initState();
    viewModel.consultationStreamCommand.execute(widget.consultationId);
  }

  @override
  void dispose() {
    viewModel.consultationStreamCommand.dispose();
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
      body: CommandStreamListenableBuilder<ConsultationEntity>(
        stream: viewModel.consultationStreamCommand,
        builder: (context, value) {
          final ConsultationEntity consultation = value;
          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    consultation.name,
                    style: theme.textTheme.titleLarge,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Id: ${consultation.id}',
                        style: theme.textTheme.bodyMedium,
                      ),
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
