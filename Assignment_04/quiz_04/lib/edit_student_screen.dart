import 'package:flutter/material.dart';
import '../student.dart';
import '../api_service.dart';

class EditStudentScreen extends StatefulWidget {
  final Student student;

  const EditStudentScreen({super.key, required this.student});

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final ApiService api = ApiService();

  late TextEditingController nameCtrl;
  late TextEditingController ageCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.student.name);
    ageCtrl = TextEditingController(text: widget.student.age.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Student")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameCtrl),
            TextField(controller: ageCtrl),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Update"),
              onPressed: () async {
                final updated = Student(
                  id: widget.student.id,
                  name: nameCtrl.text,
                  age: int.parse(ageCtrl.text),
                );
                await api.updateStudent(updated);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}