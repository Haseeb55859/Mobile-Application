import 'package:flutter/material.dart';
import 'Musicapp.dart';

void main(){
  runApp(Musicapp());
}
class Musicapp extends StatelessWidget {
  const Musicapp({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Musicapp'),
      ),
    );
  }
}
