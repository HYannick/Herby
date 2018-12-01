import 'package:flutter/material.dart';

class Plant {
  String id;
  String name;
  String imageURL;
  String imagePath;
  String description;
  DateTime lastWatering;
  int daysLeft;
  int frequency;
  String userId;

  Plant(
      {@required this.id,
      @required this.name,
      @required this.imageURL,
      @required this.imagePath,
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
    id = plantData['id'];
    imageURL = plantData['imageURL'];
    imagePath = plantData['imagePath'];
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
