import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create and update objects
    Person person1 = Person("Haseeb", 19);
    person1.setName = "Ali";
    person1.setAge = 22;

    Student student1 = Student("Fahad", 21, "Computer Science");
    student1.setCourse = "Information Technology";

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Person & Student Info")),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Person: ${person1.getName}, Age: ${person1.getAge}"),
              const SizedBox(height: 10),
              Text("Student: ${student1.getName}, "
                  "Age: ${student1.getAge}, "
                  "Course: ${student1.getCourse}"),
            ],
          ),
        ),
      ),
    );
  }
}

class Person {
  String name;
  int age;
  Person(this.name, this.age);
  void set setName(String newName) => name = newName;
  void set setAge(int newAge) => age = newAge;
  String get getName => name;
  int get getAge => age;
}

class Student extends Person {
  String course;
  Student(String name, int age, this.course) : super(name, age);
  void set setCourse(String newCourse) => course = newCourse;
  String get getCourse => course;
}
