class {{name.pascalCase()}}Entity {
  final String id;
  final String name;

  {{name.pascalCase()}}Entity(
  {
    required this.id, 
    required this.name,   
  });
}
