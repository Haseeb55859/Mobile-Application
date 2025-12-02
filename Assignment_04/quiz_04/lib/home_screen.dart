import 'package:flutter/material.dart';
import '../api_service.dart';
import '../student.dart';
import 'add_student_screen.dart';
import '../student_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService api = ApiService();
  List<Student> students = [];

  void loadData() async {
    students = await api.getStudents();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Students")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddStudentScreen(onSaved: loadData),
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, i) => StudentTile(
          s: students[i],
          onDelete: () async {
            await api.deleteStudent(students[i].id);
            loadData();
          },
          onUpdated: loadData,
        ),
      ),
    );
  }
}