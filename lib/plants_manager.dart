import 'package:flutter/material.dart';
import 'package:herby_app/plants.dart';
import 'package:herby_app/plants_control.dart';

class PlantsManager extends StatelessWidget {
  final List<Map<String, dynamic>> plants;
  final Function addPlant;
  final Function deletePlant;

  PlantsManager(this.plants, this.addPlant, this.deletePlant);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(margin: EdgeInsets.all(10.0), child: PlantsControl(addPlant)),
        Expanded(child: Plants(plants: plants, deletePlant: deletePlant))
      ],
    );
  }
}
