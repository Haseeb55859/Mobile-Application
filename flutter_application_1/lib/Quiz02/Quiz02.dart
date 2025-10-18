import 'package:flutter/material.dart';

void main() {
  runApp(ProfileApp());
}

class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _controller = TextEditingController();
  String _errorMessage = '';
  String _savedName = '';

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation == Orientation.portrait
        ? 'Portrait'
        : 'Landscape';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Icon(
              Icons.account_circle,
              size: 100,
              color: Color.fromARGB(255, 213, 83, 14),
            ),

            const SizedBox(height: 10),

            RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Haseeb Ur Rehman\n',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'haseebrehman1728@gmail.com',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Follow'),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {},
                  child: const Text('Message'),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Container(
              color: Colors.blue.shade50,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Flutter Application',
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter Your Name',
                  border: const OutlineInputBorder(),
                  errorText: _errorMessage.isEmpty ? null : _errorMessage,
                ),
                onChanged: (value) {
                  setState(() {
                    _errorMessage = value.isEmpty ? 'Username cannot be empty' : '';
                  });
                },
              ),
            ),

            const SizedBox(height: 10),

            // 👇 Added Button Below Username TextField
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_controller.text.isEmpty) {
                    _errorMessage = 'Username cannot be empty';
                  } else {
                    _errorMessage = '';
                    _savedName = _controller.text;
                  }
                });
              },
              child: const Text('Submit Here..'),
            ),

            if (_savedName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Saved Username: $_savedName',
                  style: const TextStyle(color: Colors.green),
                ),
              ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text('Current Orientation: $orientation'),
            ),
          ],
        ),
      ),
    );
  }
}
