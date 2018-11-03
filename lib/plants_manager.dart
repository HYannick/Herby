import 'package:flutter/material.dart';
import 'package:herby_app/components/bottomNav.dart';
import 'package:herby_app/plants.dart';
import 'package:herby_app/plants_control.dart';

class PlantsManager extends StatefulWidget {
  Map startingPlant;

  PlantsManager({this.startingPlant});

  @override
  State<StatefulWidget> createState() {
    return _PlantsManagerState();
  }
}

class _PlantsManagerState extends State<PlantsManager> {
  final List<Map<String, dynamic>> _plants = [];

  @override
  void initState() {
    super.initState();
    if (widget.startingPlant != null) {
      _plants.add(widget.startingPlant);
    }
  }

  void _addPlant(Map plant) {
    setState(() {
      _plants.add(plant);
    });
  }

  void _deletePlant(int index) {
    setState(() {
      _plants.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.all(10.0), child: PlantsControl(_addPlant)),
        Expanded(child: Plants(plants: _plants, deletePlant: _deletePlant)),
        BottomNav()
      ],
    );
  }
}
