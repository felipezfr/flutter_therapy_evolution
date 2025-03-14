import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/features/doctor/domain/entities/doctor_entity.dart';

import '../viewmodels/doctor_viewmodel.dart';

class DoctorDetailPage extends StatefulWidget {
  final DoctorEntity doctor;

  const DoctorDetailPage({super.key, required this.doctor});

  @override
  State<DoctorDetailPage> createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage> {
  final viewModel = Modular.get<DoctorViewmodel>();

  DoctorEntity get doctor => widget.doctor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
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
                  doctor.name,
                  style: theme.textTheme.titleLarge,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Id: ${doctor.id}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
