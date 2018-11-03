import 'package:flutter/material.dart';
import 'package:herby_app/pages/plants_list.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text(
              'Login',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
          ),
          body: Center(
            child: RaisedButton(
                child: Text('Login'),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => PlantsList()));
                }),
          )),
    );
  }
}
