import 'package:flutter/material.dart';
import 'package:herby_app/plants_manager.dart';

class PlantsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text(
              'Herby',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
          ),
          body: PlantsManager()),
    );
  }
}
