import '../../../core/command/command.dart';
import '../../../core/typedefs/result_typedef.dart';
import '../domain/entities/{{name.snakeCase()}}_entity.dart';
import '../domain/repositories/i_{{name.snakeCase()}}_repository.dart';

class {{name.pascalCase()}}Viewmodel{

  final I{{name.pascalCase()}}Repository _repository;

  {{name.pascalCase()}}Viewmodel(this._repository) {
    defaultCommand = Command0(_get{{name.pascalCase()}});
  }

  late final Command0<{{name.pascalCase()}}Entity> defaultCommand;

  Output<{{name.pascalCase()}}Entity> _get{{name.pascalCase()}}() {
    return _repository.fetchData();
  }

}