import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatefulWidget {
  @override
  DateTimePickerState createState() {
    return DateTimePickerState();
  }
}

class DateTimePickerState extends State<DateTimePicker> {
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2016),
        lastDate: DateTime(2019));

    if (picked != null && picked != _date) {
      print(
          'Date Selected ::${DateFormat('yyyy-MM-dd EEEE – kk:mm').format(_date)}');
      setState(() {
        _date = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
            'Date Selected :: ${DateFormat('yyyy-MM-dd EEEE – kk:mm').format(_date)}'),
        RaisedButton(
          onPressed: () => _selectDate(context),
          child: Text('Select a date!'),
        )
      ],
    );
  }
}
