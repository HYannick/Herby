import 'package:flutter/material.dart';
import 'package:herby_app/models/plant.dart';
import 'package:herby_app/theme.dart';

class PlantsCarousel extends StatelessWidget {
  final List<Plant> plants;
  final String title;

  final double itemHeight;

  final double itemWidth;

  PlantsCarousel(this.title, this.plants,
      {this.itemWidth = 80.0, this.itemHeight = 80.0});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 20.0,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          height: itemHeight,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: plants.length,
              itemBuilder: (BuildContext context, int index) {
                Plant plant = plants[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed<bool>('/plant/${plant.id.toString()}');
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10.0),
                    width: itemWidth,
                    height: itemHeight,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(plant.imageURL),
                            fit: BoxFit.cover),
                        color: hFadedGreen,
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                );
              }),
        )
      ],
    );
  }
}
