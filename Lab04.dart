class Person {
  String name;
  int age;

  // Constructor
  Person(this.name, this.age);

  // Setter
  void set setName(String newName) {
    name = newName;
  }

  void set setAge(int newAge) {
    age = newAge;
  }

  // Getter
  String get getName => name;
  int get getAge => age;

  // Function
  void displayInfo() {
    print("Name: $name, Age: $age");
  }
}

// Derived class: Student
class Student extends Person {
  String course;

  // Constructor
  Student(String name, int age, this.course) : super(name, age);

  // Setter
  void set setCourse(String newCourse) {
    course = newCourse;
  }

  // Getter
  String get getCourse => course;

  // Function override
  @override
  void displayInfo() {
    print("Name: $name, Age: $age, Course: $course");
  }
}

void main() {
  // Create a Person object
  Person person1 = Person("Haseeb", 19);
  person1.displayInfo();

  // Update using setter
  person1.setName = "Ali";
  person1.setAge = 22;
  print("Updated Person:");
  person1.displayInfo();

  // Create a Student object (inheritance)
  Student student1 = Student("fahad", 21, "Computer Science");
  student1.displayInfo();

  // Update student info
  student1.setCourse = "Information Technology";
  print("Updated Student:");
  student1.displayInfo();
}
