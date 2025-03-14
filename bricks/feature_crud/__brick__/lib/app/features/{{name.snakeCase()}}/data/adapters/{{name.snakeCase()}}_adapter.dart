import '../../domain/entities/{{name.snakeCase()}}_entity.dart';

class {{name.pascalCase()}}Adapter {

  static {{name.pascalCase()}}Entity fromMap(Map<String, dynamic> data) {
    return {{name.pascalCase()}}Entity(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
    );
  }

  static Map<String, dynamic> toMap({{name.pascalCase()}}Entity entity) {  
    return {
      'id': entity.id,
      'name': entity.name,     
    };
  }
}
