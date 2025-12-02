// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/activity.dart';
import 'services/api_service.dart';
import 'services/location_service.dart';
import 'repositories/activity_repository.dart';
import 'providers/activity_provider.dart';
import 'utils/hive_helper.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveHelper.init();
  final api = ApiService();
  final repo = ActivityRepository(api: api);
  runApp(MyApp(repo: repo));
}

class MyApp extends StatelessWidget {
  final ActivityRepository repo;
  const MyApp({Key? key, required this.repo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ActivityProvider>(
          create: (_) => ActivityProvider(repository: repo, locationService: LocationService()),
        ),
      ],
      child: MaterialApp(
        title: 'SmartTracker',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: HomeScreen(),
      ),
    );
  }
}
