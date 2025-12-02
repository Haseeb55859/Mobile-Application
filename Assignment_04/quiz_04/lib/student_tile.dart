import 'package:flutter/material.dart';
import '../student.dart';
import '../edit_student_screen.dart';

class StudentTile extends StatelessWidget {
  final Student s;
  final VoidCallback onDelete;
  final VoidCallback onUpdated;

  const StudentTile({
    super.key,
    required this.s,
    required this.onDelete,
    required this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(s.name),
        subtitle: Text("Age: ${s.age}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditStudentScreen(student: s),
                      ),
                    ).then((_) => onUpdated())),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}