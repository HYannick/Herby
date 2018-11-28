import 'package:flutter/material.dart';

class Plant {
  String id;
  String name;
  String imgURL;
  String description;
  DateTime lastWatering;
  int daysLeft;
  int frequency;
  String userId;

  Plant(
      {@required this.id,
      @required this.name,
      @required this.imgURL,
      @required this.description,
      @required this.lastWatering,
      @required this.daysLeft,
      @required this.frequency,
      @required this.userId});

  int getNextWatering({DateTime lastWatering, frequency}) {
    DateTime nextWatering = lastWatering.add(Duration(days: frequency));
    int daysLeft = nextWatering.difference(DateTime.now()).inDays;
    int remainingDays = daysLeft > 0 ? daysLeft : 0;
    return remainingDays;
  }

  Plant.fromJSON(plantData) {
    print(plantData);
    id = plantData['id'];
    imgURL = plantData['imgURL'];
    name = plantData['name'];
    lastWatering = DateTime.parse(plantData['lastWatering']);
    frequency = plantData['frequency'];
    daysLeft = getNextWatering(
        lastWatering: DateTime.parse(plantData['lastWatering']),
        frequency: plantData['frequency']);
    userId = plantData['userId'];
    description = plantData['description'];
  }
}
