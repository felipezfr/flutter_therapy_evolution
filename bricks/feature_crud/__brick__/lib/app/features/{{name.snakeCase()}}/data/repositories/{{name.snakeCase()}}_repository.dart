import 'package:result_dart/result_dart.dart';

import '../../../../core/typedefs/result_typedef.dart';
import '../../domain/entities/{{name.camelCase()}}_entity.dart';

abstract class I{{name.pascalCase()}}Repository {
  OutputStream<List<{{name.pascalCase()}}Entity>> get{{name.pascalCase()}}sStream();
  OutputStream<{{name.pascalCase()}}Entity> get{{name.pascalCase()}}Stream(String {{name.camelCase()}}Id);
  Output<Unit> save{{name.pascalCase()}}({{name.pascalCase()}}Entity {{name.camelCase()}});
  Output<Unit> delete{{name.pascalCase()}}(String {{name.camelCase()}}Id);
}
