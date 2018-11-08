import 'package:flutter/material.dart';
import 'package:herby_app/models/plant.dart';
import 'package:herby_app/scoped-models/plants.dart';
import 'package:scoped_model/scoped_model.dart';

class Plants extends StatelessWidget {
  Widget _buildPlantItem(BuildContext context, int index, List<Plant> plants) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
              .pushNamed<bool>('/plant/${index.toString()}')
              .then((bool value) {
            if (value) {}
          }),
      child: Card(
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTitle(plants[index]),
                Container(
                    constraints: BoxConstraints.expand(
                      height:
                          Theme.of(context).textTheme.display1.fontSize * 1.1 +
                              120.0,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        image: DecorationImage(
                            image: ExactAssetImage(plants[index].imgURL),
                            fit: BoxFit.cover,
                            alignment: Alignment(0.0, 0.25))),
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        gradient: new LinearGradient(
                            colors: [Colors.black87, Colors.transparent],
                            begin: Alignment.topCenter,
                            end: Alignment(0.0, 0.3)),
                      ),
                      child: _buildDescription(context, plants[index], index),
                    ))
              ]),
        ),
      ),
    );
  }

  Padding _buildTitle(Plant plant) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        plant.name,
        textAlign: TextAlign.left,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
    );
  }

  Row _buildDescription(BuildContext context, Plant plant, int index) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Next Watering in',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
              Text(
                '${plant.daysLeft} days',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.white),
              )
            ],
          ),
        ),
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

  Widget _buildPlantList(List<Plant> plants) {
    Widget plantList = Center(child: Text('Let\'s add some plants :D'));
    if (plants.length > 0) {
      plantList = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            _buildPlantItem(context, index, plants),
        itemCount: plants.length,
      );
    }
    return plantList;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<PlantsModel>(
        builder: (BuildContext scopedContext, Widget child, PlantsModel model) {
      return _buildPlantList(model.plants);
    });
  }
}
