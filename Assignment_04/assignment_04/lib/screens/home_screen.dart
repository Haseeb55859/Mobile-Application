// lib/screens/home_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';
import 'add_activity_screen.dart';
import 'activity_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final prov = Provider.of<ActivityProvider>(context, listen: false);
    prov.loadActivities();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ActivityProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('SmartTracker')),
      body: prov.loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ActivityListScreen(activities: prov.activities),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => AddActivityScreen()));
        },
      ),
    );
  }
}
