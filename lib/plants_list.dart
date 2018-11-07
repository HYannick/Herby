import 'package:flutter/material.dart';
import 'package:herby_app/plants.dart';

class PlantsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[Expanded(child: Plants())],
    );
  }
}
