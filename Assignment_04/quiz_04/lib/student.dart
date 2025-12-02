class Student {
  final String id;
  final String name;
  final int age;

  Student({required this.id, required this.name, required this.age});

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      age: map['age'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'age': age};
  }
}