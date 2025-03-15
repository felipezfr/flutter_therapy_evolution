import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/widgets/result_handler.dart';
import '../../../../core/command/command_stream_listenable_builder.dart';
import '../../../../core/widgets/delete_dialog.dart';
import '../viewmodels/{{name.camelCase()}}_viewmodel.dart';

import '../../domain/entities/{{name.camelCase()}}_entity.dart';

class {{name.pascalCase()}}ListPage extends StatefulWidget {
  const {{name.pascalCase()}}ListPage({super.key});

  @override
  State<{{name.pascalCase()}}ListPage> createState() => _{{name.pascalCase()}}ListPageState();
}

class _{{name.pascalCase()}}ListPageState extends State<{{name.pascalCase()}}ListPage> {
  final viewModel = Modular.get<{{name.pascalCase()}}Viewmodel>();

  @override
  void initState() {
    super.initState();
    viewModel.delete{{name.pascalCase()}}Command.addListener(_onDelete{{name.pascalCase()}});
  }

  @override
  void dispose() {
    viewModel.delete{{name.pascalCase()}}Command.removeListener(_onDelete{{name.pascalCase()}});
    viewModel.{{name.camelCase()}}sStreamCommand.dispose();
    super.dispose();
  }

  void _onDelete{{name.pascalCase()}}() {
    ResultHandler.showAlert(
      context: context,
      result: viewModel.delete{{name.pascalCase()}}Command.result,
      successMessage: 'Excluído com sucesso!',
    );
  }

  void _confirmDelete{{name.pascalCase()}}({{name.pascalCase()}}Entity {{name.camelCase()}}) {
    DeleteDialog.showDeleteConfirmation(
      context: context,
      title: 'Excluir',
      entityName: {{name.camelCase()}}.name,
      onConfirm: () {
        viewModel.delete{{name.pascalCase()}}Command.execute({{name.camelCase()}}.id);
      },
    );
  }

  void _navigateToEditPage({{name.pascalCase()}}Entity {{name.camelCase()}}) {
    Modular.to.pushNamed('./edit', arguments: {
      '{{name.camelCase()}}Entity': {{name.camelCase()}},
    });
  }

  void _navigateToDetailPage({{name.pascalCase()}}Entity {{name.camelCase()}}) {
    Modular.to.pushNamed('./detail/${{{name.camelCase()}}.id}');
  }

  void _navigateToRegisterPage() {
    Modular.to.pushNamed('./register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('{{name.pascalCase()}}'),
      ),
      body: CommandStreamListenableBuilder<List<{{name.pascalCase()}}Entity>>(
        stream: viewModel.{{name.camelCase()}}sStreamCommand,
        emptyMessage: 'Nenhum dado cadastrado',
        emptyIconData: Icons.app_registration_rounded,
        builder: (context, value) {
          return _build{{name.pascalCase()}}List(value);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToRegisterPage,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _build{{name.pascalCase()}}List(List<{{name.pascalCase()}}Entity> {{name.camelCase()}}s) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: {{name.camelCase()}}s.length,
      itemBuilder: (context, index) {
        final {{name.camelCase()}} = {{name.camelCase()}}s[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                {{name.camelCase()}}.name.isNotEmpty ? {{name.camelCase()}}.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              {{name.camelCase()}}.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text('ID: ${{{name.camelCase()}}.id}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _navigateToEditPage({{name.camelCase()}}),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete{{name.pascalCase()}}({{name.camelCase()}}),
                ),
              ],
            ),
            onTap: () => _navigateToDetailPage({{name.camelCase()}}),
          ),
        );
      },
    );
  }
}
