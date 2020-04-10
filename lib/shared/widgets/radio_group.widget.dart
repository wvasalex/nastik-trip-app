import 'package:flutter/material.dart';
import '../shared.dart';

class RadioGroupItem {
  final String value;
  final String title;
  final String subtitle;

  RadioGroupItem({
    @required this.value,
    @required this.title,
    this.subtitle,
  });
}

class RadioGroup extends StatefulWidget {
  final List<RadioGroupItem> items;
  final Function(RadioGroupItem) onChange;
  final String value;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;

  RadioGroup({
    @required this.onChange,
    @required this.items,
    this.value = '-1',
    this.titleStyle,
    this.subtitleStyle,
    Key key,
  }): super(key: key);

  @override
  _RadioGroupState createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  String _value;

  @override
  void initState() {
    _value = widget.value ?? '-1';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var items$ = widget.items.map(_item$).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: items$,
    );
  }

  Widget _item$(RadioGroupItem item) {
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        _check(item);
      },
      child: DataItem(
        leading: RoundCheckbox(
          onChange: () {
            _check(item);
          },
          checked: _value == item.value,
          size: 20,
        ),
        title: item.title,
        subtitle: item.subtitle,
        titleStyle: widget.titleStyle ?? theme.textTheme.title,
        subtitleStyle: widget.subtitleStyle ??  theme.textTheme.body2,
        underline: false,
        padding: 0,
        innerPadding: EdgeInsets.all(6),
      ),
    );
  }

  void _check(RadioGroupItem item) {
    setState(() {
      if (widget.onChange(item) != false) {
        _value = item.value;
      }
    });
  }
}
