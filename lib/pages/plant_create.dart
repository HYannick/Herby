import 'package:flutter/material.dart';
import 'package:herby_app/components/date_time_picker.dart';

class PlantCreatePage extends StatefulWidget {
  @override
  PlantCreatePageState createState() {
    return new PlantCreatePageState();
  }
}

class PlantCreatePageState extends State<PlantCreatePage> {
  Map<String, dynamic> plantForm = {
    'name': '',
    'imgURL': 'assets/Aloe Vera.jpg',
    'description': '',
    'lastWatering': null,
    'daysLeft': 0,
    'frequency': 0
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Text(
            'Create your Plant details!',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          _buildTextField(TextInputType.text, 'name', 'Name'),
          _buildTextField(
              TextInputType.multiline, 'description', 'Description'),
          DateTimePicker(),
          Column(
            children: <Widget>[
              Text(plantForm['name']),
              Text(plantForm['description']),
              Text(plantForm['lastWatering'].toString()),
            ],
          )
        ],
      ),
    );
  }

  TextField _buildTextField(
      TextInputType keyboardType, String field, String label) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
      onChanged: (String value) {
        setState(() {
          plantForm[field] = value;
        });
      },
    );
  }
}
