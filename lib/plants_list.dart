import 'package:flutter/material.dart';
import 'package:herby_app/plants.dart';

class PlantsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        SizedBox(
          height: 30.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            'Your next waterings',
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.w100, fontSize: 25.0),
          ),
        ),
        Expanded(child: Plants())
      ],
    );
  }
}
