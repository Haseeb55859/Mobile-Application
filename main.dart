import 'package:flutter/material.dart';
import 'package:flutter_application_1/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Widget Tree")),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  // LoginForm(), 
                  // Row 1
                  Row1(),
                  const Padding(padding: EdgeInsets.all(16.0)),
                  // Row 2
                  Row2(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

