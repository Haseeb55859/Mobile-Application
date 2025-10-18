import 'package:flutter/material.dart';

class Row2 extends StatelessWidget {
  const Row2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          color: Colors.yellow,
          height: 40.0,
          width: 40.0,
        ),
        const Padding(padding: EdgeInsets.all(16.0)),
        Expanded(
          child: Container(
            color: Colors.amber,
            height: 40.0,
            width: 40.0,
          ),
        ),
        const Padding(padding: EdgeInsets.all(16.0)),
        Container(
          color: Colors.brown,
          height: 40.0,
          width: 40.0,
        ),
      ],
    );
  }
}

class Row1 extends StatelessWidget {
  const Row1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                color: Colors.yellow,
                height: 100.0,
                width: 100.0,
              ),
              const Padding(padding: EdgeInsets.all(16.0)),
              
              Container(
                color: Colors.amber,
                height: 60.0,
                width: 60.0,
              ),
              const Padding(padding: EdgeInsets.all(16.0)),
              Container(
                color: Colors.brown,
                height: 40.0,
                width: 40.0,
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.lightGreen,
                    radius: 100.0,
                    child: Stack(
                      children: [
                        Container(
                          color: Colors.yellow,
                          height: 100.0,
                          width: 100.0,
                        ),
                        Container(
                          color: Colors.amber,
                          height: 60.0,
                          width: 60.0,
                        ),
                        Container(
                          color: Colors.brown,
                          height: 40.0,
                          width: 40.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
              const Text("End of the Line")
            ],
          ),
        ),
      ],
    );
  }
}


class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(25.0),
            ),
            border: OutlineInputBorder(),
            labelText: 'Enter Your Name',
          ),
        ),
        SizedBox(height: 8), 
        TextFormField(
          obscureText: true, 
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                width: 2,
                color: Colors.black
              )
            ),
            border: OutlineInputBorder(),
            labelText: 'Enter Your Password',
          ),
        ),
        SizedBox(height: 16), // spacing
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontWeight: FontWeight.bold),
            padding: EdgeInsets.fromLTRB(60, 20, 60, 20)
          ),
          onPressed: () {
          },
          child: Text("Log In"),
        ),
      ],
    );
  }
}
