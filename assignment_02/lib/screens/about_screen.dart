import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final attractions = [
      {'img': 'https://picsum.photos/200?1', 'name': 'Eiffel Tower'},
      {'img': 'https://picsum.photos/200?2', 'name': 'Great Wall'},
      {'img': 'https://picsum.photos/200?3', 'name': 'Taj Mahal'},
      {'img': 'https://picsum.photos/200?4', 'name': 'Sydney Opera'},
      {'img': 'https://picsum.photos/200?5', 'name': 'Pyramids of Giza'},
      {'img': 'https://picsum.photos/200?6', 'name': 'Statue of Liberty'},
    ];

    return Padding(
      padding: const EdgeInsets.all(8),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: attractions.map((place) {
          return Column(
            children: [
              Expanded(child: Image.network(place['img']!, fit: BoxFit.cover)),
              const SizedBox(height: 4),
              Text(place['name']!, style: const TextStyle(fontSize: 16)),
            ],
          );
        }).toList(),
      ),
    );
  }
}