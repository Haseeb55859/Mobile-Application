import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(10),
      children: [
        Text(
          'DESTINATION',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: Image.asset(
            'assets/images/img8.jpeg',
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 15),
        Text(
          'Bali, Indonesia',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Icon(Icons.star, color: Colors.orange, size: 20),
            SizedBox(width: 5),
            Text(
              '4.8   43 Reviews',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          'Beautiful beaches, temples, and sunsets.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.wifi, color: Colors.white),
            Icon(Icons.fastfood, color: Colors.white),
            Icon(Icons.directions_bus, color: Colors.white),
          ],
        ),
        SizedBox(height: 25),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 91, 54, 97),
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
          child: Text(
            'Book Now',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
