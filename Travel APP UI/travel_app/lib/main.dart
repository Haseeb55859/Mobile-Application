import 'package:flutter/material.dart';
import 'detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
          centerTitle: true,
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    DetailsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'TRAVEL APP' : 'DETAILS PAGE'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: "Details"),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List destinations = [
      {'name': 'Paris', 'url': 'assets/images/img2.jpg'},
      {'name': 'New York', 'url': 'assets/images/img3.jpg'},
      {'name': 'Bali', 'url': 'assets/images/img4.jpeg'},
      {'name': 'Dubai', 'url': 'assets/images/img5.jpeg'},
      {'name': 'Sydney', 'url': 'assets/images/img6.jpeg'},
      {'name': 'Riyadh', 'url': 'assets/images/img7.jpeg'},
    ];

    return ListView(
      padding: EdgeInsets.all(10),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Explore',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            Icon(Icons.person_outline, size: 30),
          ],
        ),
        SizedBox(height: 10),
        Center(
          child: Image.asset(
            'assets/images/img1.jpeg',
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 15),
        TextField(
          style: TextStyle(color: Colors.white), // 👈 text color white when typing
          decoration: InputDecoration(
            hintText: 'Where to?',
            hintStyle: TextStyle(color: Colors.white70),
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search, color: Colors.white70),
          ),
        ),
        SizedBox(height: 15),
        Text(
          'POPULAR DESTINATIONS',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 600,
          child: ListView.builder(
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              final destination = destinations[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: ListTile(
                  tileColor: Colors.grey[900],
                  leading: Image.asset(
                    destination['url'],
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    destination['name'],
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text('Discover More'),
        ),
      ],
    );
  }
}
