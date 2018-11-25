import 'dart:async';

import 'package:flutter/material.dart';
import 'package:herby_app/models/plant.dart';
import 'package:herby_app/scoped-models/main.dart';
import 'package:herby_app/theme.dart';
import 'package:scoped_model/scoped_model.dart';

class PlantsDetailsPage extends StatefulWidget {
  final String plantId;
  bool editMode;
  double frequency = 1.0;

  PlantsDetailsPage(this.plantId, {this.editMode: false});

  @override
  PlantsDetailsPageState createState() {
    return new PlantsDetailsPageState();
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 50.0);
    path.lineTo(size.width - 50.0, size.height - 50.0);
    var firstControlPoint = Offset(size.width, size.height - 50.0);
    var firstEndPoint = Offset(size.width, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class PlantsDetailsPageState extends State<PlantsDetailsPage>
    with SingleTickerProviderStateMixin {
  AnimationController _contentController;
  Animation<double> buttonAnimation;
  Animation<double> fadeAnimation;
  final TextStyle tableTextStyle =
      TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    _contentController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    buttonAnimation = Tween(begin: 0.0, end: -60.0)
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
                  icon: Icon(Icons.edit),
                  iconSize: 20.0,
                  onPressed: () {
                    setState(() {
                      widget.editMode = !widget.editMode;
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
                      child: Container(
                        height: 300.0,
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
    Widget content = Transform.translate(
        offset: Offset(0.0, buttonAnimation.value),
        child: Opacity(
          opacity: fadeAnimation.value,
          child: Column(
            children: <Widget>[
              _buildHeader(
                  date: plant.daysLeft, frequency: plant.frequency.round()),
              _buildDescription(description: plant.description)
            ],
          ),
        ));

    if (widget.editMode) {
      content = _buildEditMode(plant);
    }

    return Container(
        padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(50.0))),
        child: content);
  }

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

  Row _buildHeader({date: 0, frequency: 0.0}) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Next watering in',
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
                child: Row(
                  children: <Widget>[
                    Text('$date',
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 35.0),
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
          child: Image.asset(
            'assets/drop-logo--outline.png',
            width: 40.0,
          ),
        )
      ],
    );
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

  // Edit Mode
  Column _buildEditMode(Plant plant) {
    return Column(
      children: <Widget>[
        _buildFrequencyInput(frequency: plant.frequency.round()),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 150.0,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(51, 51, 51, 0.1),
                        offset: Offset(4.0, 4.0),
                        spreadRadius: 1.0,
                        blurRadius: 5.0)
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FlatButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      widget.editMode = false;
                    });
                  },
                ),
              ),
              Container(
                  width: 150.0,
                  decoration: BoxDecoration(
                    color: hMainGreen,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(51, 51, 51, 0.1),
                          offset: Offset(4.0, 4.0),
                          spreadRadius: 1.0,
                          blurRadius: 5.0)
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ScopedModelDescendant<MainModel>(builder:
                      (BuildContext scopedContext, Widget child,
                          MainModel model) {
                    return FlatButton(
                      child: model.isLoading
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ))
                          : Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                      onPressed: () {
                        int daysLeft = model.getNextWatering(
                            lastWatering: plant.lastWatering,
                            frequency: widget.frequency.round());

                        Map<String, dynamic> updatedPlant = {
                          'id': plant.id,
                          'daysLeft': daysLeft,
                          'frequency': widget.frequency.round(),
                          'description': plant.description,
                          'lastWatering': plant.lastWatering,
                          'name': plant.name,
                          'imgURL': plant.imgURL,
                          'userId': plant.userId
                        };
                        model.selectPlant(plant.id);
                        model.editPlant(updatedPlant).then((_) {
                          setState(() {
                            widget.editMode = false;
                          });
                        });
                      },
                    );
                  }))
            ],
          ),
        )
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
                      widget.frequency = value.roundToDouble();
                    });
                  },
                  value: widget.frequency,
                  max: 30.0,
                  min: 1.0,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
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
                  widget.frequency.round().toString(),
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
