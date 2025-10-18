import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/img.jpg'),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            color: Colors.blue.shade50,
            child: Text(
              'Welcome to Travel Guide App! Discover amazing destinations around the world.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 20),
              children: [
                TextSpan(
                  text: 'Explore ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                TextSpan(
                  text: 'the World with Us',
                  style: TextStyle(color: Colors.orange),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter destination name',
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Exploring destinations...')),
              );
            },
            child: Text('Explore'),
          ),
          TextButton(
            onPressed: () {
              print('TextButton pressed');
            },
            child: Text('More Info'),
          ),
        ],
      ),
    );
  }
}