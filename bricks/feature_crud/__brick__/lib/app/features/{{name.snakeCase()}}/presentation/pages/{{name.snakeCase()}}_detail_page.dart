import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/features/{{name.camelCase()}}/domain/entities/{{name.camelCase()}}_entity.dart';

import '../viewmodels/{{name.camelCase()}}_viewmodel.dart';

class {{name.pascalCase()}}DetailPage extends StatefulWidget {
  final {{name.pascalCase()}}Entity {{name.camelCase()}};

  const {{name.pascalCase()}}DetailPage({super.key, required this.{{name.camelCase()}}});

  @override
  State<{{name.pascalCase()}}DetailPage> createState() => _{{name.pascalCase()}}DetailPageState();
}

class _{{name.pascalCase()}}DetailPageState extends State<{{name.pascalCase()}}DetailPage> {
  final viewModel = Modular.get<{{name.pascalCase()}}Viewmodel>();

  {{name.pascalCase()}}Entity get {{name.camelCase()}} => widget.{{name.camelCase()}};

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
        ),
      ),
    );
  }
}
