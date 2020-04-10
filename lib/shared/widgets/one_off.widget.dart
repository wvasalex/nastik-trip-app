import 'package:flutter/material.dart';

class OneOff extends StatefulWidget {
  final List<String> items;
  final int selected;
  final Function(int) onChange;

  OneOff({
    @required this.items,
    this.onChange,
    this.selected = 0,
  });

  @override
  _OneOffState createState() => _OneOffState();
}

class _OneOffState extends State<OneOff> {
  int _selected;

  @override
  void initState() {
    _selected = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: theme.secondaryHeaderColor,
        ),
      ),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(child: child, opacity: animation);
        },
        child: Container(
          key: ValueKey(_selected),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.items.map((String label) {
              return _item$(
                context,
                label,
                widget.items.indexOf(label),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _item$(
    BuildContext context,
    String label,
    int value,
  ) {
    final ThemeData theme = Theme.of(context);
    final bool active = value == _selected;
    final Color bgColor = active ? theme.primaryColor : Colors.white;
    final Color textColor = active ? Colors.white : theme.secondaryHeaderColor;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          _setActive(value);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: theme.textTheme.subtitle.copyWith(
              color: textColor,
              fontSize: 14,
              height: 18 / 14,
            ),
          ),
        ),
      ),
    );
  }

  void _setActive(int value) {
    if (widget.onChange != null) {
      widget.onChange(value);
    }

    setState(() {
      _selected = value;
    });
  }
}
