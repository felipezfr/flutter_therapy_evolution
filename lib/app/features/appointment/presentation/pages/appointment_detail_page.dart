import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/features/appointment/domain/entities/appointment_entity.dart';

import '../../../../core/command/command_stream_listenable_builder.dart';
import '../viewmodels/appointment_viewmodel.dart';

class AppointmentDetailPage extends StatefulWidget {
  final String appointmentId;

  const AppointmentDetailPage({super.key, required this.appointmentId});

  @override
  State<AppointmentDetailPage> createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  final viewModel = Modular.get<AppointmentViewmodel>();

  @override
  void initState() {
    super.initState();
    viewModel.appointmentStreamCommand.execute(widget.appointmentId);
  }

  @override
  void dispose() {
    viewModel.appointmentStreamCommand.dispose();
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
      body: CommandStreamListenableBuilder<AppointmentEntity>(
        stream: viewModel.appointmentStreamCommand,
        builder: (context, value) {
          final AppointmentEntity appointment = value;
          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    appointment.date.day.toString(),
                    style: theme.textTheme.titleLarge,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Id: ${appointment.id}',
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
