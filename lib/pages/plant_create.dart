import 'package:flutter/material.dart';

class PlantCreatePage extends StatefulWidget {
  @override
  PlantCreatePageState createState() {
    return new PlantCreatePageState();
  }
}

class PlantCreatePageState extends State<PlantCreatePage> {
  String titleText = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          onChanged: (String value) {
            setState(() {
              titleText = value;
            });
          },
        ),
        Text(titleText)
      ],
    );
  }
}
