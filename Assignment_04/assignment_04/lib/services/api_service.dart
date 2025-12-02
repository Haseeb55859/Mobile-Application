// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/activity.dart';

class ApiService {
  // For Android emulator use 10.0.2.2, for real device replace with server host
  static const String baseUrl = 'http://10.0.2.2:3000';

  Future<List<Activity>> fetchActivities() async {
    final resp = await http.get(Uri.parse('$baseUrl/activities'));
    if (resp.statusCode == 200) {
      final List<dynamic> list = jsonDecode(resp.body);
      return list.map((e) => Activity.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch activities');
  }

  Future<Activity> createActivity(Activity a) async {
    final resp = await http.post(
      Uri.parse('$baseUrl/activities'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(a.toJson()),
    );
    if (resp.statusCode == 201) {
      return Activity.fromJson(jsonDecode(resp.body));
    }
    throw Exception('Failed to create activity');
  }

  Future<void> deleteActivity(String id) async {
    final resp = await http.delete(Uri.parse('$baseUrl/activities/$id'));
    if (resp.statusCode != 200) throw Exception('Failed to delete');
  }

  Future<Activity> updateActivity(Activity a) async {
    final resp = await http.put(
      Uri.parse('$baseUrl/activities/${a.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(a.toJson()),
    );
    if (resp.statusCode == 200) {
      return Activity.fromJson(jsonDecode(resp.body));
    }
    throw Exception('Failed to update activity');
  }
}
