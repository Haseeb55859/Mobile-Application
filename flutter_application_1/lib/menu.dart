import 'package:flutter/material.dart';

import 'Quiz02/Quiz02.dart';
void main (){
runApp(ProfileApp());

}
class ProfileApp extends StatefulWidget {
  const ProfileApp({super.key});

  @override
  State<ProfileApp> createState() => _ProfileAppState();
}

class _ProfileAppState extends State<ProfileApp> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title:Text("ProfileApp")
  

      ),
    );
  }
}
