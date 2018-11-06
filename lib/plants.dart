import 'package:flutter/material.dart';

class Plants extends StatelessWidget {
  final List<Map<String, dynamic>> plants;

  final Function deletePlant;

  Plants({this.plants = const [], this.deletePlant});

  Widget _buildPlantItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
              .pushNamed<bool>('/plant/${index.toString()}')
              .then((bool value) {
            if (value) {
              deletePlant(index);
            }
          }),
      child: Card(
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTitle(index),
                Container(
                    constraints: BoxConstraints.expand(
                      height:
                          Theme.of(context).textTheme.display1.fontSize * 1.1 +
                              120.0,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        image: DecorationImage(
                            image: ExactAssetImage(plants[index]['imgURL']),
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

  Padding _buildTitle(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        plants[index]['name'],
        textAlign: TextAlign.left,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
    );
  }

  Row _buildDescription(BuildContext context, Map plant, int index) {
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
                '${plant['daysLeft']} days',
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

  Widget _buildPlantList() {
    Widget plantList = Center(child: Text('Let\'s add some plants :D'));
    if (plants.length > 0) {
      plantList = ListView.builder(
        itemBuilder: _buildPlantItem,
        itemCount: plants.length,
      );
    }
    return plantList;
  }

  @override
  Widget build(BuildContext context) {
    return _buildPlantList();
  }
}
