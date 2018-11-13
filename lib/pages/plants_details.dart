import 'package:flutter/material.dart';
import 'package:herby_app/components/gradientImageBackground.dart';
import 'package:herby_app/models/plant.dart';
import 'package:herby_app/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class PlantsDetailsPage extends StatefulWidget {
  final int plantIndex;
  bool editMode;
  double frequency = 1.0;

  PlantsDetailsPage(this.plantIndex, {this.editMode: false});

  @override
  PlantsDetailsPageState createState() {
    return new PlantsDetailsPageState();
  }
}

class PlantsDetailsPageState extends State<PlantsDetailsPage> {
  final Color blueyColor = Color.fromRGBO(158, 181, 199, 1.0);

  final Color mainGreen = Color.fromRGBO(140, 216, 207, 1.0);

  final Color fadedGreen = Color.fromRGBO(140, 216, 207, 0.5);

  final TextStyle tableTextStyle =
      TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () {
      Navigator.pop(context, false);
      return Future.value(false);
    }, child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext scopedContext, Widget child, MainModel model) {
      Plant plant = model.allPlants[widget.plantIndex];
      return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: widget.editMode ? 700.0 : 400.0,
              child: Hero(
                tag: 'plantImg-${widget.plantIndex}',
                child: GradientImageBackground(
                    imgURL: plant.imgURL, color: Colors.black87),
              ),
            ),
            SafeArea(
              child: ListView(
                children: <Widget>[
                  _buildNavigation(context),
                  _buildTitle(title: plant.name),
                  _buildContent(plant, model.editPlant),
                ],
              ),
            ),
          ],
        ),
      );
    }));
  }

  Container _buildContent(Plant plant, Function editPlant) {
    Column content = Column(
      children: <Widget>[
        _buildHeader(date: plant.daysLeft, frequency: plant.frequency.round()),
        _buildDescription(description: plant.description),
      ],
    );

    if (widget.editMode) {
      content = _buildEditMode(plant, editPlant);
    }

    return Container(
        padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(50.0))),
        child: content);
  }

  Padding _buildNavigation(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.chevron_left),
                color: Colors.white,
                iconSize: 30.0,
                onPressed: () => Navigator.pop(context, false)),
            Spacer(),
            Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.edit),
                    color: Colors.white,
                    iconSize: 30.0,
                    onPressed: () {
                      setState(() {
                        widget.editMode = !widget.editMode;
                      });
                    }),
                IconButton(
                    icon: Icon(Icons.delete_outline),
                    color: Colors.white,
                    iconSize: 30.0,
                    onPressed: () => _showWarningDialog(context)),
              ],
            ),
          ],
        ));
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

  // Display Mode
  Container _buildTitle({String title = ''}) {
    return Container(
      height: widget.editMode ? 350.0 : 200.0,
      alignment: AlignmentDirectional.centerStart,
      margin: EdgeInsets.all(20.0),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.white, fontSize: 45.0, fontWeight: FontWeight.bold),
      ),
    );
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
                style: TextStyle(fontWeight: FontWeight.w100, fontSize: 18.0),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Text('$date',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 40.0,
                            color: mainGreen)),
                    Text(' Days',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 40.0)),
                  ],
                ),
              ),
              Text('Watering every $frequency days',
                  style: TextStyle(color: blueyColor, fontSize: 15.0)),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 35.0),
          decoration: BoxDecoration(
              color: mainGreen,
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
          border: Border.all(color: fadedGreen, width: 5.0)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildHead(
                    text: 'Temperature', style: TextStyle(color: blueyColor)),
                _buildHead(
                    text: 'Humidity', style: TextStyle(color: blueyColor)),
                _buildHead(text: 'Light', style: TextStyle(color: blueyColor)),
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
  Column _buildEditMode(Plant plant, Function editPlant) {
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
                  color: mainGreen,
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
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    int daysLeft = plant.lastWatering
                            .add(Duration(days: widget.frequency.round()))
                            .day -
                        DateTime.now().day;

                    if (daysLeft < 0) {
                      daysLeft = 0;
                    }

                    Plant updatedPlant = Plant(
                        id: plant.id,
                        daysLeft: daysLeft,
                        frequency: widget.frequency.round(),
                        description: plant.description,
                        lastWatering: plant.lastWatering,
                        name: plant.name,
                        imgURL: plant.imgURL,
                        userId: plant.userId);
                    editPlant(updatedPlant, widget.plantIndex);
                    setState(() {
                      widget.editMode = false;
                    });
                  },
                ),
              )
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
                  activeColor: mainGreen,
                  inactiveColor: fadedGreen,
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
                  color: mainGreen,
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
