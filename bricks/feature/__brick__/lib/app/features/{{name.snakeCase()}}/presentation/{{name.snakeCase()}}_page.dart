import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '{{name.snakeCase()}}_viewmodel.dart';

import '../../../core/alert/alerts.dart';

class {{name.pascalCase()}}Page extends StatefulWidget {
  const {{name.pascalCase()}}Page({super.key});

  @override
  State<{{name.pascalCase()}}Page> createState() => _{{name.pascalCase()}}PageState();
}

class _{{name.pascalCase()}}PageState extends State<{{name.pascalCase()}}Page> {
  final viewModel = Modular.get<{{name.pascalCase()}}Viewmodel>();

  @override
  void initState() {
    super.initState();
    viewModel.defaultCommand.addListener(listener);
  }

  listener() {
    viewModel.defaultCommand.result?.fold(
      (success) {},
      (failure) {
        Alerts.showFailure(context, failure.message);
      },
    );
  }

  @override
  void dispose() {
    viewModel.defaultCommand.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('{{name.pascalCase()}}'),
      ),
      body: Container(),
    );
  }
}
