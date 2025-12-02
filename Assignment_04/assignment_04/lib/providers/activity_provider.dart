// lib/providers/activity_provider.dart
import 'dart:math';

import 'package:flutter/foundation.dart';
import '../models/activity.dart';
import '../repositories/activity_repository.dart';
import '../services/location_service.dart';

class ActivityProvider extends ChangeNotifier {
  final ActivityRepository repository;
  final LocationService locationService;

  List<Activity> _activities = [];
  List<Activity> get activities => _activities;

  bool loading = false;
  String? error;

  ActivityProvider({required this.repository, required this.locationService});

  Future<void> loadActivities() async {
    try {
      loading = true;
      notifyListeners();
      _activities = await repository.fetchAll();
    } catch (e) {
      error = e.toString();
      // fallback to offline
      _activities = repository.getOffline();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<Activity> addActivity({required String imageBase64, String note = ''}) async {
    final pos = await locationService.getCurrentLocation();
    final id = Random().nextInt(1000000).toString();
    final activity = Activity(
      id: id,
      latitude: pos.latitude,
      longitude: pos.longitude,
      imageBase64: imageBase64,
      timestamp: DateTime.now(),
      note: note,
    );
    final created = await repository.create(activity);
    _activities.insert(0, created);
    notifyListeners();
    return created;
  }

  Future<void> deleteActivity(String id) async {
    await repository.delete(id);
    _activities.removeWhere((a) => a.id == id);
    notifyListeners();
  }
}
