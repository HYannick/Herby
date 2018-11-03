import 'package:flutter/material.dart';
import 'package:herby_app/plants.dart';

class PlantsList extends StatelessWidget {
  final List<Map<String, dynamic>> plants;
  final Function addPlant;
  final Function deletePlant;

  PlantsList(this.plants, this.addPlant, this.deletePlant);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(child: Plants(plants: plants, deletePlant: deletePlant))
      ],
    );
  }
}
