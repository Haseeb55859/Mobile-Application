import 'package:flutter/material.dart';
import '../student.dart';
import '../api_service.dart';

class AddStudentScreen extends StatelessWidget {
  final Function onSaved;
  AddStudentScreen({super.key, required this.onSaved});

  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final ApiService api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Student")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: ageCtrl, decoration: const InputDecoration(labelText: "Age")),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Save"),
              onPressed: () async {
                final s = Student(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameCtrl.text,
                  age: int.parse(ageCtrl.text),
                );
                await api.addStudent(s);
                onSaved();
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}