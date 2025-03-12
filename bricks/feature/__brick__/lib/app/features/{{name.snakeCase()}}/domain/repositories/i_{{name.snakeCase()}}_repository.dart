import '../../../../core/typedefs/result_typedef.dart';
import '../entities/{{name.snakeCase()}}_entity.dart';

abstract class I{{name.pascalCase()}}Repository {
  Output<{{name.pascalCase()}}Entity> fetchData();
}