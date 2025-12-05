import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;

  void registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      // Firebase Auth me user create
      String email = "${userIdController.text}@app.com";
      UserCredential cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: passwordController.text);

      // Firestore me user info save using Firebase UID as doc ID
      ChatUser newUser = ChatUser(
        name: nameController.text,
        userId: userIdController.text,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid) // important: UID se doc banaya
          .set(newUser.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User Registered Successfully")));

      Navigator.pop(context); // login screen pe le jaye

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? "Error")));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
                validator: (val) => val!.isEmpty ? "Enter Name" : null,
              ),
              TextFormField(
                controller: userIdController,
                decoration: InputDecoration(labelText: "User ID"),
                validator: (val) => val!.isEmpty ? "Enter User ID" : null,
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (val) => val!.length < 6
                    ? "Password should be at least 6 chars"
                    : null,
              ),
              SizedBox(height: 20),
              loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: registerUser, child: Text("Register"))
            ],
          ),
        ),
      ),
    );
  }
}
