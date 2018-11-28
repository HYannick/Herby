import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:herby_app/models/plant.dart';
import 'package:herby_app/scoped-models/main.dart';
import 'package:herby_app/theme.dart';
import 'package:scoped_model/scoped_model.dart';

class PlantsList extends StatelessWidget {
  final String avatarURL = 'assets/avatar-sample.jpg';
  final String backgroundURL = 'assets/home-bg.jpg';
  final String username = 'Math';

  Widget _buildPlantItem(BuildContext context, int index, Plant plant,
      Function deletePlant, Function checkWateringState) {
    return GestureDetector(
      onTap: () {
        print(plant.id);
        return Navigator.of(context)
            .pushNamed<bool>('/plant/${plant.id.toString()}')
            .then((bool value) {
          if (value) {
            deletePlant(plant);
          }
        });
      },
      child: Card(
        color: Colors.transparent,
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 30.0,
              ),
              Expanded(
                child:
                    Stack(alignment: Alignment.bottomCenter, children: <Widget>[
                  Hero(
                    tag: 'plantImg-${plant.id}',
                    child: Container(
                        constraints: BoxConstraints.expand(height: 130.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(45.0),
                              topLeft: Radius.circular(45.0),
                              bottomRight: Radius.circular(45.0),
                              bottomLeft: Radius.circular(20.0)),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(33, 33, 33, 0.4),
                                offset: Offset(4.0, 10.0),
                                spreadRadius: 1.0,
                                blurRadius: 10.0)
                          ],
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(45.0),
                                topLeft: Radius.circular(45.0),
                                bottomRight: Radius.circular(45.0),
                                bottomLeft: Radius.circular(20.0)),
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
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(45.0),
                          topLeft: Radius.circular(45.0),
                          bottomRight: Radius.circular(45.0),
                          bottomLeft: Radius.circular(20.0)),
                      gradient: new LinearGradient(
                          colors: [Colors.transparent, Colors.black87],
                          begin: Alignment.topCenter,
                          end: Alignment(0.0, 1.0)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: _buildDescription(plant, checkWateringState),
                  )
                ]),
              ),
              SizedBox(
                width: 15.0,
              ),
              Container(
                width: 80.0,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: hWhite, borderRadius: BorderRadius.circular(50.0)),
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
                          fontSize: 20.0,
                          color: Colors.black),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildDescription(Plant plant, Function needWatering) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
            child: Text(
          plant.name,
          style: TextStyle(
              color: hMainGreen, fontWeight: FontWeight.bold, fontSize: 18.0),
        )),
        Container(
            alignment: Alignment.topCenter,
            child: needWatering(
                    lastWatering: plant.lastWatering,
                    frequency: plant.frequency)
                ? SvgPicture.asset(
                    'assets/drop-logo--plain.svg',
                    color: hWhite,
                    width: 30.0,
                  )
                : Icon(
                    Icons.check,
                    size: 30.0,
                    color: hWhite,
                  ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 5.0,
            top: MediaQuery.of(context).size.height / 2 - 100.0,
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(
                'Your next watering',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w100),
              ),
            ),
          ),
          Positioned(
              right: 55.0,
              top: 0.0,
              child: Container(
                width: 2.0,
                height: MediaQuery.of(context).size.height,
                color: Colors.black12,
              )),
          CustomScrollView(
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
          return _buildPlantItem(
              context, index, plant, model.deletePlant, model.needWatering);
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
          SizedBox(width: 20.0),
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
