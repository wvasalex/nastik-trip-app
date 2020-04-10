import 'package:flutter/material.dart';
import '../shared.dart';

class TimePicker extends StatefulWidget {
  final Function(int) onChange;
  final int value;

  TimePicker({
    @required this.onChange,
    this.value,
  });

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  int _value;

  @override
  void initState() {
    _value = widget.value ?? Helpers.localTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _pick(context);
      },
      child: _handle$(context),
    );
  }

  Widget _handle$(BuildContext context) {
    String label = 'Выбрать время';

    if (_value != null) {
      label = Helpers.date(
        date: (_value / 1000).floor(),
        format: 'H:mm',
      );
    }

    return DataItem(title: label);
  }

  Future<void> _pick(BuildContext context) async {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(_value);
    final TimeOfDay initial = TimeOfDay.fromDateTime(date);

    final TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: initial,
    );

    if (time != null) {
      setState(() {
        _value = DateTime(date.year, date.month, date.day, time.hour, time.minute).millisecondsSinceEpoch;
        widget.onChange(_value);
      });
    }
  }
}
