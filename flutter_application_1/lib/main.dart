import 'package:flutter/material.dart';
import 'Practice.dart';
void main() {
  runApp(Practice());
}

class Practice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: nameprint(),
      home: NamePrint(),

    );
  }
}


