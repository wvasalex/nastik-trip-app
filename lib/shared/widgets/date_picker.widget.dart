import 'package:flutter/material.dart';
import '../shared.dart';

class DatePicker extends StatefulWidget {
  final Function(int) onChange;
  final int value;

  DatePicker({
    @required this.onChange,
    this.value,
  });

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  int _value;

  @override
  void initState() {
    _value = widget.value ?? DateTime.now().millisecondsSinceEpoch;
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
    String label = 'Выбрать дату';

    if (_value != null) {
      label = Helpers.date(
        date: (_value / 1000).floor(),
        format: 'd MMMM y',
      );
    }

    return DataItem(title: label);
  }

  Future<void> _pick(BuildContext context) async {
    final DateTime initial = DateTime.fromMillisecondsSinceEpoch(_value);

    final DateTime date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(initial.year),
      lastDate: DateTime(initial.year + 1),
    );

    if (date != null) {
      setState(() {
        _value = date.millisecondsSinceEpoch;
        widget.onChange(_value);
      });
    }
  }
}
