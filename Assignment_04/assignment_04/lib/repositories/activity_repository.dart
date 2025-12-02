// lib/repositories/activity_repository.dart
import 'package:hive/hive.dart';
import '../models/activity.dart';
import '../services/api_service.dart';
import '../utils/hive_helper.dart';

class ActivityRepository {
  final ApiService api;
  final Box _box = Hive.box(HiveHelper.kBoxName);

  ActivityRepository({required this.api});

  Future<List<Activity>> fetchAll() async {
    final remote = await api.fetchActivities();
    // store latest 5 locally
    _cacheLatest(remote);
    return remote;
  }

  Future<Activity> create(Activity a) async {
    final created = await api.createActivity(a);
    final list = _getCachedList();
    list.insert(0, created);
    _storeLimited(list);
    return created;
  }

  Future<void> delete(String id) async {
    await api.deleteActivity(id);
    final list = _getCachedList();
    list.removeWhere((e) => e.id == id);
    _storeLimited(list);
  }

  List<Activity> getOffline() {
    return _getCachedList();
  }

  void _cacheLatest(List<Activity> list) {
    _storeLimited(list);
  }

  List<Activity> _getCachedList() {
    final raw = _box.get('recentActivities') as List<dynamic>?;
    if (raw == null) return [];
    return raw.map((e) => Activity.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  void _storeLimited(List<Activity> list) {
    final limited = list.take(5).map((e) => e.toJson()).toList();
    _box.put('recentActivities', limited);
  }
}
