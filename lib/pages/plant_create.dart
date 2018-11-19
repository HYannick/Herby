import 'package:flutter/material.dart';
import 'package:herby_app/components/date_time_picker.dart';
import 'package:herby_app/components/gradientImageBackground.dart';
import 'package:herby_app/models/plant.dart';
import 'package:herby_app/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class PlantCreatePage extends StatefulWidget {
  PlantCreatePage();

  @override
  PlantCreatePageState createState() {
    return new PlantCreatePageState();
  }
}

class PlantCreatePageState extends State<PlantCreatePage> {
  final Color mainGreen = Color.fromRGBO(140, 216, 207, 1.0);
  final Color fadedGreen = Color.fromRGBO(140, 216, 207, 0.5);
  double frequency = 1.0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> plantForm = {
    'name': '',
    'imgURL': 'assets/Aloe Vera.jpg',
    'description': '',
    'lastWatering': null,
    'daysLeft': 0,
    'frequency': 1
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: <Widget>[
            ScopedModelDescendant<MainModel>(
                builder: (BuildContext context, Widget child, model) {
              return Container(
                height: 400.0,
                child: GradientImageBackground(
                    imageFile: model.imageURL,
                    color: Color.fromRGBO(219, 237, 145, 1.0),
                    fadeColor: Color.fromRGBO(132, 204, 187, 1.0),
                    gradientOpacity: 0.50),
              );
            }),
            ListView(
              children: <Widget>[
                _buildTitle(),
                Container(
                  padding: EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(50.0))),
                  child: _buildForm(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _buildTextFormField(TextInputType.text, 'name', 'Name', minChar: 2),
          _buildTextFormField(
              TextInputType.multiline, 'description', 'Description',
              minChar: 2),
          _buildWateringDatePicker(),
          _buildFrequencyInput(),
          _buildSubmitButton()
        ],
      ),
    );
  }

  Container _buildTitle() {
    return Container(
      height: 300.0,
      padding: const EdgeInsets.all(20.0),
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        'Plants\nInfos',
        style: TextStyle(
            fontSize: 45.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  ScopedModelDescendant _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext scopedContext, Widget child, MainModel model) {
      return Container(
          width: 170.0,
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
          child: !model.isLoading
              ? FlatButton(
                  child: Text(
                    'Add Plant',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  onPressed: () =>
                      _submitPlant(model.addPlant, model.allPlants))
              : Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  )));
    });
  }

  void _submitPlant(Function addPlant, List<Plant> plants) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    plantForm['frequency'] = frequency.round();
    if (plantForm['lastWatering'] == null) {
      plantForm['lastWatering'] = DateTime.now();
    }
    plantForm['daysLeft'] = plantForm['lastWatering']
            .add(Duration(days: plantForm['frequency']))
            .day -
        DateTime.now().day;

    if (plantForm['daysLeft'] < 0) {
      plantForm['daysLeft'] = 0;
    }

    _formKey.currentState.save();

    addPlant(plantForm).then((bool success) {
      if (success) {
        Navigator.pushReplacementNamed(context, '/');
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Something went wrong :('),
                content: Text('Please try again!'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              );
            });
      }
    });
  }

  Column _buildWateringDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
        ),
        Container(
          width: 170.0,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(51, 51, 51, 0.1),
                  offset: Offset(4.0, 4.0),
                  spreadRadius: 1.0,
                  blurRadius: 5.0)
            ],
          ),
          child: DateTimePicker(
            _submitDate,
            label: 'Last Watering',
          ),
        ),
      ],
    );
  }

  Container _buildFrequencyInput() {
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
                      frequency = value.roundToDouble();
                    });
                  },
                  value: frequency,
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
                  frequency.round().toString(),
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

  TextFormField _buildTextFormField(
      TextInputType keyboardType, String field, String label,
      {int minChar}) {
    return TextFormField(
        keyboardType: keyboardType,
        maxLines: keyboardType == TextInputType.multiline ? 4 : 1,
        decoration: InputDecoration(
          hintText: label,
          hintStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black38),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: mainGreen)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: mainGreen)),
        ),
        validator: (String value) {
          if (value.isEmpty || value.length <= minChar) {
            return '$label is required and should be $minChar+ characters long.';
          }
        },
        onSaved: (String value) => plantForm[field] = value);
  }

  void _submitDate(date) => plantForm['lastWatering'] = date;
}
