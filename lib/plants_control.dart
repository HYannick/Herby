import 'package:flutter/material.dart';

class PlantsControl extends StatelessWidget {
  final Function addPlant;
  PlantsControl(this.addPlant);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: RaisedButton(
          child: Text('Add a plant :D'),
          onPressed: () {
            addPlant({
              'title': 'Dracena Marginata',
              'imgURL': 'assets/Dracena Marginata.jpg',
              'description':
                  'Watering this kind of plant directly depends on the temperature of the place. Have fun Watering them! And be nice',
              'daysLeft': 3,
              'frequency': 15,
            });
          }),
    );
  }
}
