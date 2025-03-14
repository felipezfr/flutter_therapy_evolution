class {{name.pascalCase()}}Entity {
  final String id;
  final String name;

  {{name.pascalCase()}}Entity(
  {
    required this.id, 
    required this.name,   
  });

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
