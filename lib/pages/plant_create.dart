import 'package:flutter/material.dart';
import 'package:herby_app/components/date_time_picker.dart';

class PlantCreatePage extends StatefulWidget {
  final Function addPlant;
  PlantCreatePage(this.addPlant);

  @override
  PlantCreatePageState createState() {
    return new PlantCreatePageState();
  }
}

class PlantCreatePageState extends State<PlantCreatePage> {
  final Color greenyColor = Color.fromRGBO(39, 200, 181, 1.0);
  double frequency = 1.0;
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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: <Widget>[
          Center(
            child: Text(
              'Add your Plant details!',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
          ),
          _buildTextField(TextInputType.text, 'name', 'Name'),
          _buildTextField(
              TextInputType.multiline, 'description', 'Description'),
          _buildWateringDatePicker(),
          _buildFrequencyInput(),
          RaisedButton(
            child: Text('Add Plant'),
            onPressed: () {
              plantForm['frequency'] = frequency.round();
              plantForm['daysLeft'] = plantForm['lastWatering']
                      .add(Duration(days: plantForm['frequency']))
                      .day -
                  DateTime.now().day;

              if (plantForm['daysLeft'] < 0) {
                plantForm['daysLeft'] = 0;
              }
              widget.addPlant(plantForm);
            },
          )
        ],
      ),
    );
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

  TextField _buildTextField(
      TextInputType keyboardType, String field, String label) {
    return TextField(
      keyboardType: keyboardType,
      maxLines: keyboardType == TextInputType.multiline ? 4 : 1,
      decoration: InputDecoration(labelText: label),
      onChanged: (String value) {
        setState(() {
          plantForm[field] = value;
        });
      },
    );
  }

  void _submitDate(date) {
    setState(() {
      plantForm['lastWatering'] = date;
    });
  }
}
