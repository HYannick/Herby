import 'package:flutter/material.dart';
import 'package:herby_app/components/gradientImageBackground.dart';

class AuthPage extends StatefulWidget {
  @override
  AuthPageState createState() {
    return new AuthPageState();
  }
}

class AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Stack(children: <Widget>[
        GradientImageBackground(
          imgURL: 'assets/auth_background@2x.png',
          color: Colors.black87,
          opacity: 0.5,
        ),
        Column(children: <Widget>[
          Expanded(
              child: Center(
            child: RaisedButton(
                child: Text(
                  'Login',
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                }),
          )),
        ])
      ]),
    ));
  }
}
