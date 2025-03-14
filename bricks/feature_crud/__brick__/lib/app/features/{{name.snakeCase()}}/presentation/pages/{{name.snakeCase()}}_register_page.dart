import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_therapy_evolution/app/core/widgets/result_handler.dart';

import '../viewmodels/{{name.camelCase()}}_viewmodel.dart';
import '../../domain/entities/{{name.camelCase()}}_entity.dart';

class {{name.pascalCase()}}RegisterPage extends StatefulWidget {
  final {{name.pascalCase()}}Entity? {{name.camelCase()}};

  const {{name.pascalCase()}}RegisterPage({
    super.key,
    this.{{name.camelCase()}},
  });

  @override
  State<{{name.pascalCase()}}RegisterPage> createState() => _{{name.pascalCase()}}RegisterPageState();
}

class _{{name.pascalCase()}}RegisterPageState extends State<{{name.pascalCase()}}RegisterPage> {
  final viewModel = Modular.get<{{name.pascalCase()}}Viewmodel>();
  {{name.pascalCase()}}Entity? get {{name.camelCase()}} => widget.{{name.camelCase()}};
  bool _isEditMode = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel.save{{name.pascalCase()}}Command.addListener(_save{{name.pascalCase()}}Listener);

    _isEditMode = widget.{{name.camelCase()}} != null;

    if (_isEditMode) {
      _load{{name.pascalCase()}}();
    }
  }

  void _load{{name.pascalCase()}}() {
    _nameController.text = {{name.camelCase()}}!.name;
  }

  void _save{{name.pascalCase()}}Listener() {
    ResultHandler.showAlert(
      context: context,
      result: viewModel.save{{name.pascalCase()}}Command.result,
      successMessage:
          _isEditMode ? 'Atualizado com sucesso!' : 'Cadastrado com sucesso!',
      onSuccess: (value) {
        Modular.to.pop();
      },
    );
  }

  void _save{{name.pascalCase()}}() {
    if (_formKey.currentState!.validate()) {
      final new{{name.pascalCase()}} = {{name.pascalCase()}}Entity(
        id: _isEditMode ? {{name.camelCase()}}!.id : '',
        name: _nameController.text,
      );

      viewModel.save{{name.pascalCase()}}Command.execute(new{{name.pascalCase()}});
    }
  }

  @override
  void dispose() {
    viewModel.save{{name.pascalCase()}}Command.removeListener(_save{{name.pascalCase()}}Listener);
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Editar' : 'Cadastrar'),
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o nome';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            PrimaryButtonDs(
              isLoading: viewModel.save{{name.pascalCase()}}Command.running,
              onPressed: _save{{name.pascalCase()}},
              title: _isEditMode ? 'Salvar Alterações' : 'Cadastrar',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
