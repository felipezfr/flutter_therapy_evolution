import 'package:flutter_modular/flutter_modular.dart';

import '../../core/core_module.dart';
import 'data/repositories/{{name.camelCase()}}_repository_impl.dart';
import 'data/repositories/{{name.camelCase()}}_repository.dart';
import 'presentation/pages/{{name.camelCase()}}_detail_page.dart';
import 'presentation/pages/{{name.camelCase()}}_list_page.dart';
import 'presentation/pages/{{name.camelCase()}}_register_page.dart';
import 'presentation/viewmodels/{{name.camelCase()}}_viewmodel.dart';

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
    r.child('/', child: (context) => {{name.pascalCase()}}ListPage());
    r.child(
      '/detail',
      child: (context) => {{name.pascalCase()}}DetailPage(
        {{name.camelCase()}}: r.args.data['{{name.camelCase()}}Entity'],
      ),
    );
    r.child('/register', child: (context) => {{name.pascalCase()}}RegisterPage());
    r.child(
      '/edit',
      child: (context) =>
          {{name.pascalCase()}}RegisterPage({{name.camelCase()}}: r.args.data['{{name.camelCase()}}Entity']),
    );
  }
}
