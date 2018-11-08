import 'package:flutter/material.dart';
import 'package:herby_app/components/date_time_picker.dart';
import 'package:herby_app/models/plant.dart';
import 'package:herby_app/scoped-models/plants.dart';
import 'package:scoped_model/scoped_model.dart';

class PlantCreatePage extends StatefulWidget {
  PlantCreatePage();

  @override
  PlantCreatePageState createState() {
    return new PlantCreatePageState();
  }
}

class PlantCreatePageState extends State<PlantCreatePage> {
  final Color greenyColor = Color.fromRGBO(39, 200, 181, 1.0);
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Center(
                child: Text(
                  'Add your Plant details!',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
              ),
              _buildTextFormField(TextInputType.text, 'name', 'Name',
                  minChar: 2),
              _buildTextFormField(
                  TextInputType.multiline, 'description', 'Description',
                  minChar: 2),
              _buildWateringDatePicker(),
              _buildFrequencyInput(),
              _buildSubmitButton()
            ],
          ),
        ),
      ),
    );
  }

  ScopedModelDescendant _buildSubmitButton() {
    return ScopedModelDescendant<PlantsModel>(
        builder: (BuildContext scopedContext, Widget child, PlantsModel model) {
      return RaisedButton(
          child: Text('Add Plant'),
          onPressed: () => _submitPlant(model.addPlant, model.plants));
    });
  }

  void _submitPlant(Function addPlant, List<Plant> plants) {
    if (!_formKey.currentState.validate() ||
        plantForm['lastWatering'] == null) {
      return;
    }
    plantForm['frequency'] = frequency.round();
    plantForm['daysLeft'] = plantForm['lastWatering']
            .add(Duration(days: plantForm['frequency']))
            .day -
        DateTime.now().day;

    if (plantForm['daysLeft'] < 0) {
      plantForm['daysLeft'] = 0;
    }
    _formKey.currentState.save();
    addPlant(Plant(
        frequency: plantForm['frequency'],
        imgURL: plantForm['imgURL'],
        lastWatering: plantForm['lastWatering'],
        daysLeft: plantForm['daysLeft'],
        description: plantForm['description'],
        name: plantForm['name']));
  }

  Column _buildWateringDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Text('When was your last watering?'),
        ),
        DateTimePicker(_submitDate),
      ],
    );
  }

  Row _buildFrequencyInput() {
    return Row(
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
            padding: EdgeInsets.symmetric(vertical: 20.0),
            decoration: BoxDecoration(
                color: greenyColor, borderRadius: BorderRadius.circular(20.0)),
            child: Center(
              child: Text(
                frequency.round().toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 45.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
      ],
    );
  }

  TextFormField _buildTextFormField(
      TextInputType keyboardType, String field, String label,
      {int minChar}) {
    return TextFormField(
        keyboardType: keyboardType,
        maxLines: keyboardType == TextInputType.multiline ? 4 : 1,
        decoration: InputDecoration(labelText: label),
        validator: (String value) {
          if (value.isEmpty || value.length <= minChar) {
            return '$label is required and should be $minChar+ characters long.';
          }
        },
        onSaved: (String value) => plantForm[field] = value);
  }

  void _submitDate(date) => plantForm['lastWatering'] = date;
}
