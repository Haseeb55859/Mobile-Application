import 'package:flutter/material.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final destinations = [
      {'name': 'Paris', 'desc': 'The City of Light and love.'},
      {'name': 'Tokyo', 'desc': 'A city that blends tradition and technology.'},
      {'name': 'Istanbul', 'desc': 'Where Europe meets Asia.'},
      {'name': 'New York', 'desc': 'The city that never sleeps.'},
      {'name': 'London', 'desc': 'Historic landmarks and modern charm.'},
      {'name': 'Sydney', 'desc': 'Home of the Opera House.'},
      {'name': 'Rome', 'desc': 'Ancient ruins and Italian culture.'},
      {'name': 'Dubai', 'desc': 'Luxury in the desert.'},
      {'name': 'Bangkok', 'desc': 'Vibrant street life and temples.'},
      {'name': 'Cairo', 'desc': 'Gateway to the Pyramids.'},
    ];

    return ListView.builder(
      itemCount: destinations.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(destinations[index]['name']!),
          subtitle: Text(destinations[index]['desc']!),
          leading: const Icon(Icons.place),
        );
      },
    );
  }
}