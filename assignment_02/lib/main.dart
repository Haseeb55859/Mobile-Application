import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'list_screen.dart';
import 'screens/about_screen.dart';
void main(){
  runApp(TravelGuideApp());
}
class TravelGuideApp extends StatefulWidget {
  const TravelGuideApp({super.key});

  @override
  State<TravelGuideApp> createState() => _TravelGuideAppState();
}

class _TravelGuideAppState extends State<TravelGuideApp> {
  int _selectedIndex =0; 
  List _screens = [
    HomeScreen(),
    ListScreen(),
    AboutScreen(),
    

  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Travel Guide'),),
        body: _screens [_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          currentIndex: _selectedIndex ,
          items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "HOME"),
          BottomNavigationBarItem(icon: Icon(Icons.list),label: "LIST"),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: "ABOUT"),
        ]),

      ),
    );
  }
}