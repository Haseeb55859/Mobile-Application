// lib/models/activity.dart
import 'dart:convert';

class Activity {
  final String id;
  final double latitude;
  final double longitude;
  final String imageBase64; // store image as base64 for simple upload
  final DateTime timestamp;
  final String note;

  Activity({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.imageBase64,
    required this.timestamp,
    this.note = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'latitude': latitude,
        'longitude': longitude,
        'imageBase64': imageBase64,
        'timestamp': timestamp.toIso8601String(),
        'note': note,
      };

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json['id'].toString(),
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        imageBase64: json['imageBase64'] ?? '',
        timestamp: DateTime.parse(json['timestamp']),
        note: json['note'] ?? '',
      );
}
