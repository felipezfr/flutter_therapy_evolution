import 'package:result_dart/result_dart.dart';

import '../../../../core/command/command.dart';
import '../../data/repositories/{{name.camelCase()}}_repository.dart';
import '../../domain/entities/{{name.camelCase()}}_entity.dart';

class {{name.pascalCase()}}Viewmodel {
  final I{{name.pascalCase()}}Repository _repository;

  {{name.pascalCase()}}Viewmodel(this._repository) {
    {{name.camelCase()}}sStreamCommand = CommandStream0(_repository.get{{name.pascalCase()}}sStream);
    save{{name.pascalCase()}}Command = Command1(_repository.save{{name.pascalCase()}});
    delete{{name.pascalCase()}}Command = Command1(_repository.delete{{name.pascalCase()}});

    {{name.camelCase()}}sStreamCommand.execute();
  }

  late final CommandStream0<List<{{name.pascalCase()}}Entity>> {{name.camelCase()}}sStreamCommand;
  late final Command1<Unit, {{name.pascalCase()}}Entity> save{{name.pascalCase()}}Command;
  late final Command1<Unit, String> delete{{name.pascalCase()}}Command;
}
