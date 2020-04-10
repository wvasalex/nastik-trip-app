import 'package:flutter/material.dart';
import '../services/helpers/helpers.dart';
import 'date_picker.widget.dart';
import 'time_picker.widget.dart';

class DateTimePicker extends StatefulWidget {
  final Function(int) onChange;
  final int value;

  DateTimePicker({
    this.onChange,
    this.value,
  });

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  int _value;

  @override
  void initState() {
    _value = widget.value ?? Helpers.localTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: DatePicker(
            onChange: (int date) {
              final DateTime d = DateTime.fromMicrosecondsSinceEpoch(date * 1000);
              final DateTime t = DateTime.fromMicrosecondsSinceEpoch(_value * 1000);

              _setValue(DateTime(
                d.year,
                d.month,
                d.day,
                t.hour,
                t.minute,
              ).millisecondsSinceEpoch);
            },
            value: _value,
          ),
        ),
        Expanded(
          child: TimePicker(
            onChange: (int date) {
              final DateTime d = DateTime.fromMicrosecondsSinceEpoch(_value * 1000);
              final DateTime t = DateTime.fromMicrosecondsSinceEpoch(date * 1000);

              _setValue(DateTime(
                d.year,
                d.month,
                d.day,
                t.hour,
                t.minute,
              ).millisecondsSinceEpoch);
            },
            value: _value,
          ),
        ),
      ],
    );
  }

  void _setValue(int date) {
    setState(() {
      _value = date;
    });

    widget.onChange(_value);
  }
}
