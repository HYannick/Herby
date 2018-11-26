import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:herby_app/models/plant.dart';
import 'package:herby_app/scoped-models/main.dart';
import 'package:herby_app/theme.dart';
import 'package:scoped_model/scoped_model.dart';

class PlantsDetailsPage extends StatefulWidget {
  final String plantId;

  PlantsDetailsPage(this.plantId);

  @override
  PlantsDetailsPageState createState() {
    return new PlantsDetailsPageState();
  }
}

enum _modes { editMode, wateredMode, viewMode }

class PlantsDetailsPageState extends State<PlantsDetailsPage>
    with TickerProviderStateMixin {
  AnimationController _contentController;
  AnimationController _buttonController;
  Animation<double> contentAnimation;
  Animation<double> fadeAnimation;
  Animation<double> buttonAnimation;
  double sliderFrequency = 1.0;
  var mode;
  final TextStyle tableTextStyle =
      TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    mode = _modes.viewMode;
    _contentController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);

    _buttonController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _buttonController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _buttonController.reverse();
      }
    });

    buttonAnimation = Tween(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _buttonController, curve: cubicEase))
          ..addListener(() {
            setState(() {});
          });
    contentAnimation = Tween(begin: 0.0, end: -60.0)
        .animate(CurvedAnimation(parent: _contentController, curve: cubicEase))
          ..addListener(() {
            setState(() {});
          });
    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(_contentController)
      ..addListener(() {
        setState(() {});
      });
    Timer(Duration(milliseconds: 100), () {
      _contentController.forward();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () {
      Navigator.pop(context, false);
      return Future.value(false);
    }, child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext scopedContext, Widget child, MainModel model) {
      model.selectPlant(widget.plantId);
      Plant plant = model.selectedPlant;
      double containerHeight = 300.0;
      if (mode == _modes.editMode || mode == _modes.wateredMode) {
        containerHeight = 400.0;
      }
      return Scaffold(
        backgroundColor: hWhite,
        body: SafeArea(
            child: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            backgroundColor: hWhite,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              plant.name,
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              IconButton(
                  icon: mode == _modes.editMode
                      ? Icon(Icons.remove_red_eye)
                      : Icon(Icons.edit),
                  iconSize: 20.0,
                  onPressed: () {
                    setState(() {
                      mode = mode == _modes.editMode
                          ? _modes.viewMode
                          : _modes.editMode;
                    });
                  }),
              IconButton(
                  icon: Icon(Icons.delete_outline),
                  iconSize: 20.0,
                  onPressed: () => _showWarningDialog(context)),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Row(
                children: <Widget>[
                  Expanded(
                    child: Hero(
                      tag: 'plantImg-${plant.id}',
                      child: AnimatedContainer(
                        duration: hDuration300,
                        curve: cubicEase,
                        height: containerHeight,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(50.0),
                                bottomRight: Radius.circular(20.0)),
                            image: DecorationImage(
                                image: AssetImage(plant.imgURL),
                                fit: BoxFit.cover)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              plant.name,
                              style: TextStyle(
                                  color: hWhite,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50.0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Row(
                          children: <Widget>[
                            Text('Watering every ',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 18.0)),
                            Text('${plant.frequency} ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                    fontSize: 18.0)),
                            Text('days',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 18.0)),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              _buildContent(plant)
            ]),
          )
        ])),
      );
    }));
  }

  Container _buildContent(Plant plant) {
    Widget content;
    switch (mode) {
      case _modes.editMode:
        content = _buildEditBottom(plant);
        break;
      case _modes.viewMode:
        content = _buildDescription(description: plant.description);
        break;
      case _modes.wateredMode:
        content = _buildWateredContainer();
        break;
      default:
        content = _buildDescription(description: plant.description);
    }

    return Container(
        padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(50.0))),
        child: Transform.translate(
            offset: Offset(0.0, contentAnimation.value),
            child: Opacity(
              opacity: fadeAnimation.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildHeader(date: plant.daysLeft, plant: plant),
                  content
                ],
              ),
            )));
  }

  Column _buildWateredContainer() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          Text(
            'Plants ready for watering',
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.0,
          ),
          ScopedModelDescendant<MainModel>(builder:
              (BuildContext scopedContext, Widget child, MainModel model) {
            List<Plant> nonWateredPlants = model.getNonWateredPlants;
            return Container(
              height: 80.0,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: nonWateredPlants.length,
                  itemBuilder: (BuildContext context, int index) {
                    Plant nPlant = nonWateredPlants[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed<bool>('/plant/${nPlant.id.toString()}');
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10.0),
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(nPlant.imgURL),
                                fit: BoxFit.cover),
                            color: hFadedGreen,
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                    );
                  }),
            );
          }),
        ],
      );

  Future _showWarningDialog(BuildContext context) {
    return showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure? :('),
            content: Text('This action cannot be undone.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Nooo! Abort!'),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                  child: Text('Yes, Delete!'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                  })
            ],
          );
        },
        context: context);
  }

  Row _buildHeader({date: 0, Plant plant}) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                mode == _modes.editMode
                    ? 'Watering Frequency'
                    : 'Next watering in',
                style: TextStyle(
                  color: hWhite,
                  fontWeight: FontWeight.w100,
                  fontSize: 18.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                child: mode == _modes.editMode
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Slider(
                          label: 'Watering Frequency',
                          activeColor: hMainGreen,
                          inactiveColor: hFadedGreen,
                          onChanged: (double value) {
                            setState(() {
                              sliderFrequency = value.roundToDouble();
                            });
                          },
                          value: sliderFrequency,
                          max: 30.0,
                          min: 1.0,
                        ))
                    : Row(
                        children: <Widget>[
                          Text('${plant.daysLeft}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 40.0,
                                  color: hMainGreen)),
                          Text(' Days',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 40.0)),
                        ],
                      ),
              ),
            ],
          ),
        ),
        ScopedModelDescendant<MainModel>(builder:
            (BuildContext scopedContext, Widget child, MainModel model) {
          return GestureDetector(
            onTap: () {
              if (mode == _modes.editMode) {
                return;
              }
              DateTime now = DateTime.now();
              int safeDays = 4;

              if (now.difference(plant.lastWatering).inDays <
                  plant.frequency - safeDays) {
                _showWateringWarning(plant, model);
              } else {
                _waterPlant(model, plant);
                _buttonController.forward();
                setState(() {
                  mode = _modes.wateredMode;
                });
              }
            },
            child: Transform.scale(
              scale: mode == _modes.editMode ? 1.0 : buttonAnimation.value,
              child: Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                      color: hMainGreen,
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(51, 51, 51, 0.2),
                            offset: Offset(4.0, 4.0),
                            spreadRadius: 1.0,
                            blurRadius: 5.0)
                      ],
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          topLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(30.0))),
                  child: Center(
                    child: mode == _modes.editMode
                        ? Text(sliderFrequency.round().toString(),
                            style: TextStyle(
                                color: hWhite,
                                fontSize: 45.0,
                                fontWeight: FontWeight.bold))
                        : SvgPicture.asset(
                            'assets/drop-logo--plain.svg',
                            color: Colors.white,
                            width: 50.0,
                          ),
                  )),
            ),
          );
        }),
      ],
    );
  }

  Future _showWateringWarning(Plant plant, MainModel model) {
    return showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Warning',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: hMainGreen)),
            content: Row(
              children: <Widget>[
                Text('You still have '),
                Text(
                  plant.daysLeft.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(' to water it.'),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Wait a bit!',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                onPressed: () => Navigator.pop(context, true),
              ),
              RaisedButton(
                  color: hMainGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Text(
                    'Water it!',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _waterPlant(model, plant);
                    setState(() {
                      mode = _modes.wateredMode;
                    });
                    Navigator.pop(context, true);
                  })
            ],
          );
        },
        context: context);
  }

  void _waterPlant(MainModel model, Plant plant) {
    DateTime now = DateTime.now();
    int daysLeft = model.getNextWatering(
        lastWatering: DateTime.now(), frequency: plant.frequency.round());

    Map<String, dynamic> updatedPlant = {
      'id': plant.id,
      'daysLeft': daysLeft,
      'frequency': plant.frequency.round(),
      'description': plant.description,
      'lastWatering': now,
      'name': plant.name,
      'imgURL': plant.imgURL,
      'userId': plant.userId
    };
    print(updatedPlant['daysLeft']);
//            model.selectPlant(plant.id);
//            model.editPlant(updatedPlant);
  }

  Container _buildDescription({description: 'Lorem Ipsum'}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Watering infos',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
            ),
          ),
          Text(description),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Plants infos',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
            ),
          ),
          _buildTable(),
        ],
      ),
    );
  }

  Container _buildTable() {
    Padding _buildHead({String text, double padding = 10.0, TextStyle style}) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Text(
          text,
          style: style,
        ),
      );
    }

    Padding _buildCells({String text, double padding = 10.0, TextStyle style}) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Text(text, style: style),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: hFadedGreen, width: 5.0)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildHead(
                    text: 'Temperature',
                    style: TextStyle(color: Colors.black54)),
                _buildHead(
                    text: 'Humidity', style: TextStyle(color: Colors.black54)),
                _buildHead(
                    text: 'Light', style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              _buildCells(text: '18-28 °C', style: tableTextStyle),
              _buildCells(text: '70-75 %', style: tableTextStyle),
              _buildCells(text: '5k to 10k lux', style: tableTextStyle),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildEditBottom(Plant plant) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    mode = _modes.viewMode;
                  });
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              ScopedModelDescendant<MainModel>(builder:
                  (BuildContext scopedContext, Widget child, MainModel model) {
                return RaisedButton(
                    color: hMainGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0)),
                    onPressed: () {
                      int daysLeft = model.getNextWatering(
                          lastWatering: plant.lastWatering,
                          frequency: sliderFrequency.round());

                      Map<String, dynamic> updatedPlant = {
                        'id': plant.id,
                        'daysLeft': daysLeft,
                        'frequency': sliderFrequency.round(),
                        'description': plant.description,
                        'lastWatering': plant.lastWatering,
                        'name': plant.name,
                        'imgURL': plant.imgURL,
                        'userId': plant.userId
                      };
                      model.selectPlant(plant.id);
                      model.editPlant(updatedPlant).then((_) {
                        setState(() {
                          mode = _modes.viewMode;
                        });
                      });
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: model.isLoading
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ))
                          : Text(
                              'Save',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                    ));
              }),
            ],
          ),
        ),
      ],
    );
  }

  Container _buildFrequencyInput({int frequency}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text('Watering Frequency'),
                ),
                Slider(
                  label: 'Watering Frequency',
                  activeColor: hMainGreen,
                  inactiveColor: hFadedGreen,
                  onChanged: (double value) {
                    setState(() {
                      sliderFrequency = value.roundToDouble();
                    });
                  },
                  value: sliderFrequency,
                  max: 30.0,
                  min: 1.0,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 90.0,
              padding: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                  color: hMainGreen,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0))),
              child: Center(
                child: Text(
                  sliderFrequency.round().toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
