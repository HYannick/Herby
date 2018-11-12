import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatefulWidget {
  final Function submitDate;
  final String label;
  final bool enableDateLabel;

  @override
  DateTimePickerState createState() {
    return DateTimePickerState();
  }

  DateTimePicker(this.submitDate,
      {this.label: 'Select a date', this.enableDateLabel: true});
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
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Column(
        children: <Widget>[
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          widget.enableDateLabel
              ? Text(
                  DateFormat('dd MMM. yyyy').format(_date).toString(),
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w100,
                      color: Color.fromRGBO(140, 216, 207, 1.0)),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
