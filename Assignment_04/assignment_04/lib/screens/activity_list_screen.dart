// lib/screens/activity_list_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../widgets/map_widget.dart';
import 'package:intl/intl.dart';

class ActivityListScreen extends StatelessWidget {
  final List<Activity> activities;
  const ActivityListScreen({Key? key, required this.activities}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return activities.isEmpty
        ? Center(child: Text('No activities yet.'))
        : ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, i) {
              final a = activities[i];
              final date = DateFormat.yMd().add_jm().format(a.timestamp);
              final imageBytes = a.imageBase64.isNotEmpty ? base64Decode(a.imageBase64) : null;
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: ExpansionTile(
                  title: Text('Activity ${a.id}'),
                  subtitle: Text(date),
                  children: [
                    if (imageBytes != null) Image.memory(imageBytes, height: 180, fit: BoxFit.cover),
                    SizedBox(height: 8),
                    SizedBox(height: 200, child: SimpleMap(latitude: a.latitude, longitude: a.longitude)),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(a.note),
                    ),
                    ButtonBar(
                      children: [
                        TextButton(
                          onPressed: () async {
                            // delete
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('Delete?'),
                                content: Text('Delete this activity?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: Text('No')),
                                  TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Yes')),
                                ],
                              ),
                            );
                            if (confirmed == true) {
                              // call provider deletion through context:
                              final provider = Provider.of<dynamic>(context, listen: false);
                              // we rely on ActivityProvider being available higher; use context.read
                              // since this is a StatelessWidget we avoid type issues: use Provider.of
                              final prov = Provider.of(provider.runtimeType, context, listen: false);
                            }
                          },
                          child: Text('Delete'),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          );
  }
}
