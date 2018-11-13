import 'package:flutter/material.dart';

class Plant {
  final String id;
  final String name;
  final String imgURL;
  final String description;
  final DateTime lastWatering;
  final int daysLeft;
  final int frequency;
  final String userId;

  Plant(
      {@required this.id,
      @required this.name,
      @required this.imgURL,
      @required this.description,
      @required this.lastWatering,
      @required this.daysLeft,
      @required this.frequency,
      @required this.userId});
}
