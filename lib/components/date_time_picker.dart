import 'dart:async';

import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget {
  final Function submitDate;

  @override
  DateTimePickerState createState() {
    return DateTimePickerState();
  }

  DateTimePicker(this.submitDate);
}

class DateTimePickerState extends State<DateTimePicker> {
  DateTime _date = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        selectableDayPredicate: (DateTime val) =>
            val.isAfter(_date) ? false : true,
        firstDate: DateTime(2016),
        lastDate: DateTime(2019));

    if (picked != null) {
      setState(() {
        _date = picked;
      });
      widget.submitDate(_date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RaisedButton(
          onPressed: () => _selectDate(context),
          child: Text('Select a date!'),
        )
      ],
    );
  }
}
