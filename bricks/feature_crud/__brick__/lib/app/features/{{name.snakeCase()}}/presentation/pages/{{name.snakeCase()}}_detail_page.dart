import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/features/{{name.camelCase()}}/domain/entities/{{name.camelCase()}}_entity.dart';

import '../../../../core/command/command_stream_listenable_builder.dart';
import '../viewmodels/{{name.camelCase()}}_viewmodel.dart';

class {{name.pascalCase()}}DetailPage extends StatefulWidget {
  final String {{name.camelCase()}}Id;

  const {{name.pascalCase()}}DetailPage({super.key, required this.{{name.camelCase()}}Id});

  @override
  State<{{name.pascalCase()}}DetailPage> createState() => _{{name.pascalCase()}}DetailPageState();
}

class _{{name.pascalCase()}}DetailPageState extends State<{{name.pascalCase()}}DetailPage> {
  final viewModel = Modular.get<{{name.pascalCase()}}Viewmodel>();

  @override
  void initState() {
    super.initState();
    viewModel.{{name.camelCase()}}StreamCommand.execute(widget.{{name.camelCase()}}Id);
  }

  @override
  void dispose() {
    viewModel.{{name.camelCase()}}StreamCommand.dispose();
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
      body: CommandStreamListenableBuilder<{{name.pascalCase()}}Entity>(
        stream: viewModel.{{name.camelCase()}}StreamCommand,
        builder: (context, value) {
          final {{name.pascalCase()}}Entity {{name.camelCase()}} = value;
          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    {{name.camelCase()}}.name,
                    style: theme.textTheme.titleLarge,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Id: ${{{name.camelCase()}}.id}',
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
