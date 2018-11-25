import 'package:flutter/material.dart';
import 'package:herby_app/models/plant.dart';
import 'package:herby_app/scoped-models/main.dart';
import 'package:herby_app/theme.dart';
import 'package:scoped_model/scoped_model.dart';

class Plants extends StatelessWidget {
  Widget _buildPlantItem(
      BuildContext context, int index, Plant plant, Function deletePlant) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
              .pushNamed<bool>('/plant/${plant.id.toString()}')
              .then((bool value) {
            if (value) {
              deletePlant(plant);
            }
          }),
      child: Card(
        color: Colors.transparent,
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      '${plant.daysLeft}',
                      style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 50.0,
                          color: hMainGreen),
                    ),
                    Text(
                      'Days',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.black),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Stack(children: <Widget>[
                  Hero(
                    tag: 'plantImg-${plant.id}',
                    child: Container(
                        constraints: BoxConstraints.expand(height: 130.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: FadeInImage(
                              placeholder:
                                  AssetImage('assets/drop-logo--outline.png'),
                              image: AssetImage(
                                plant.imgURL,
                              ),
                              fit: BoxFit.cover,
                            ))),
                  ),
                  Container(
                    height: 130.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      gradient: new LinearGradient(
                          colors: [Colors.black87, Colors.transparent],
                          begin: Alignment.topCenter,
                          end: Alignment(0.0, 0.3)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: _buildDescription(plant),
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildDescription(Plant plant) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child: Text(
          plant.name,
          style: TextStyle(
              color: hMainGreen, fontWeight: FontWeight.bold, fontSize: 16.0),
        )),
        Container(
          alignment: Alignment.topCenter,
          child: Image.asset(
            'assets/drop-icon--white.png',
            width: 25.0,
          ),
        )
      ],
    );
  }

  Widget _buildPlantList(
      List<Plant> plants, Function deletePlant, bool isLoading) {
    Widget plantList = Center(
        child: Text(
      'Empty! Add some plants :D',
      style: TextStyle(fontSize: 15.0),
    ));

    if (plants.length > 0 && !isLoading) {
      plantList = ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          Plant plant = plants[index];
          return _buildPlantItem(context, index, plant, deletePlant);
        },
        itemCount: plants.length,
      );
    } else if (isLoading) {
      plantList = Center(
        child: CircularProgressIndicator(),
      );
    }
    return plantList;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext scopedContext, Widget child, MainModel model) {
      return _buildPlantList(
          model.allPlants, model.deletePlant, model.isLoading);
    });
  }
}
