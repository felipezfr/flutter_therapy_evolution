import 'package:flutter_modular/flutter_modular.dart';

import '../../core/core_module.dart';
import 'data/repositories/{{name.snakeCase()}}_repository_impl.dart';
import 'domain/repositories/i_{{name.snakeCase()}}_repository.dart';
import 'presentation/{{name.snakeCase()}}_page.dart';
import 'presentation/{{name.snakeCase()}}_viewmodel.dart';

class {{name.pascalCase()}}Module extends Module {
    @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i.addLazySingleton<I{{name.pascalCase()}}Repository>({{name.pascalCase()}}RepositoryImpl.new);
    i.addLazySingleton({{name.pascalCase()}}Viewmodel.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => {{name.pascalCase()}}Page());
  }
}

