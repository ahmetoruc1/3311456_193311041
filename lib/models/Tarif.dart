/*class Dog {
  final int id;
  final String name;
  final int age;

  Dog({required this.id, required this.name, required this.age});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}*/
class Tarif {
  //final int id;
  final String tarifname;
  final String yayinlayanName;

  Tarif( {required this.tarifname,required this.yayinlayanName});

  //Dog({required this.id, required this.name, required this.age});

  Map<String, dynamic> toMap() {
    return {
      'tarifname': tarifname,
      'yayinlayanName': yayinlayanName,
    };
  }
  @override
  String toString() {
    return 'Tarif{tarifname: $tarifname, yayinlayanName: $yayinlayanName}';
  }
}