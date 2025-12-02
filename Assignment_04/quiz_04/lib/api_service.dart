import 'dart:convert';
import 'package:http/http.dart' as http;
import 'student.dart';

class ApiService {
  final String baseUrl = "http://localhost:3000";

  Future<List<Student>> getStudents() async {
    final res = await http.get(Uri.parse("$baseUrl/students"));
    final List data = jsonDecode(res.body);
    return data.map((e) => Student.fromMap(e)).toList();
  }

  Future<void> addStudent(Student s) async {
    await http.post(Uri.parse("$baseUrl/students"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(s.toMap()));
  }

  Future<void> updateStudent(Student s) async {
    await http.put(Uri.parse("$baseUrl/students/${s.id}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(s.toMap()));
  }

  Future<void> deleteStudent(String id) async {
    await http.delete(Uri.parse("$baseUrl/students/$id"));
  }
}