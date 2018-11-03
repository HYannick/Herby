import 'package:flutter/material.dart';
import 'package:herby_app/components/bottomNav.dart';
import 'package:herby_app/components/gradientImageBackground.dart';

class PlantsDetailsPage extends StatelessWidget {
  final String title;
  final String imgURL;
  final String description;
  final int daysLeft;
  final int frequency;

  final Color blueyColor = Color.fromRGBO(158, 181, 199, 1.0);
  final Color greenyColor = Color.fromRGBO(39, 200, 181, 1.0);
  final TextStyle tableTextStyle =
      TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold);

  PlantsDetailsPage(
      {this.title,
      this.imgURL,
      this.description,
      this.daysLeft,
      this.frequency});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        bottomNavigationBar: BottomNav(),
        body: Stack(
          children: <Widget>[
            GradientImageBackground(imgURL: imgURL, color: Colors.black87),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildNavigation(context),
                        _buildTitle(title: title),
                        _buildContent(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Expanded _buildContent() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(date: 3, frequency: 15),
            _buildDescription(description: description),
          ],
        ),
      ),
    );
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
                    onPressed: () => print('Edit Mode')),
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

  Container _buildTitle({String title = ''}) {
    return Container(
      margin: EdgeInsets.all(30.0),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.white, fontSize: 45.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Row _buildHeader({date: '0', frequency: '0'}) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Next watering in',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Text('${daysLeft} days',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0)),
              ),
              Text('Watering every ${frequency} days',
                  style: TextStyle(color: blueyColor, fontSize: 15.0)),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
          decoration: BoxDecoration(
              color: greenyColor, borderRadius: BorderRadius.circular(20.0)),
          child: Image.asset(
            'assets/drop-icon--white-outline.png',
            width: 40.0,
          ),
        )
      ],
    );
  }

  Expanded _buildDescription({description: 'Lorem Ipsum'}) {
    return Expanded(
        child: Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 70.0,
      child: ListView(
        children: <Widget>[
          Text(
            'Watering infos',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
          ),
          Divider(),
          Text(description),
          Divider(),
          Text(
            'Plants infos',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
          ),
          _buildTable(),
        ],
      ),
    ));
  }

  Table _buildTable() {
    Padding _buildHead({String text, double padding = 10.0, TextStyle style}) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Text(
          text,
          style: style,
        ),
      );
    }

    Padding _buildCells({String text, double padding = 10.0, TextStyle style}) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: Text(text, style: style),
      );
    }

    return Table(
      children: [
        TableRow(children: [
          _buildHead(text: 'Temperature', style: TextStyle(color: blueyColor)),
          _buildHead(text: 'Humidiy', style: TextStyle(color: blueyColor)),
          _buildHead(text: 'Light', style: TextStyle(color: blueyColor)),
        ]),
        TableRow(
            decoration: BoxDecoration(
                border: Border.all(
                  color: blueyColor,
                ),
                borderRadius: BorderRadius.circular(10.0)),
            children: [
              _buildCells(text: '18-28 °C', style: tableTextStyle),
              _buildCells(text: '70-75 %', style: tableTextStyle),
              _buildCells(text: '5k to 10k lux', style: tableTextStyle),
            ])
      ],
    );
  }
}
