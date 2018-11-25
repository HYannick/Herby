import 'package:flutter/material.dart';
import 'package:herby_app/models/plant.dart';
import 'package:herby_app/scoped-models/main.dart';
import 'package:herby_app/theme.dart';
import 'package:scoped_model/scoped_model.dart';

class PlantsList extends StatelessWidget {
  final String avatarURL = 'assets/avatar-sample.jpg';
  final String backgroundURL = 'assets/home-bg.jpg';
  final String username = 'Math';

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
                        constraints: BoxConstraints.expand(height: 170.0),
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
                    height: 170.0,
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            backgroundColor: hWhite,
            expandedHeight: 110.0,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(),
            ),
          ),
          _buildContent(),
        ],
      ),
    );
  }

  ScopedModelDescendant<MainModel> _buildContent() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      Widget plantList = SliverList(
        delegate: SliverChildListDelegate([
          Center(
              child: Text(
            'Empty! Add some plants :D',
            style: TextStyle(fontSize: 15.0),
          ))
        ]),
      );
      if (model.allPlants.length > 0 && !model.isLoading) {
        plantList = SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
          Plant plant = model.allPlants[index];
          return _buildPlantItem(context, index, plant, model.deletePlant);
        }, childCount: model.allPlants.length));
      } else if (model.isLoading) {
        plantList = SliverList(
          delegate: SliverChildListDelegate([
            Container(
                height: 300.0,
                child: Center(child: CircularProgressIndicator()))
          ]),
        );
        Center();
      }
      return plantList;
    });
  }

  Expanded _buildHeadTitle(Map<String, String> title) {
    return Expanded(
        child: Row(
      children: <Widget>[
        Text(
          title['s1'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
        Text(
          title['s2'],
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25.0, color: hMainGreen),
        ),
      ],
    ));
  }

  Padding _buildHeader() {
    Map<String, String> title = {'s1': 'Hello, ', 's2': '$username!'};
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          _buildHeadTitle(title),
          Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5.0),
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0)),
                image: DecorationImage(
                    image: ExactAssetImage(avatarURL),
                    fit: BoxFit.cover,
                    alignment: Alignment(0.0, 0.25))),
          )
        ],
      ),
    );
  }
}
