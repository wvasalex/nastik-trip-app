import 'package:flutter/material.dart';

class RoundCheckbox extends StatelessWidget {
  final Function onChange;
  final bool checked;

  RoundCheckbox({
    @required this.onChange,
    @required this.checked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChange,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            width: 2,
            color: Color(0xFF323132),
          ),
        ),
        child: _indicator(context),
      ),
    );
  }

  Widget _indicator(BuildContext context) {
    if (checked != true) {
      return Container();
    }

    return Container(
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  static wrap({
    @required Widget child,
    @required Function onChange,
    @required bool checked,
    bool disabled = false,
  }) {
    if (disabled) {
      return child;
    }

    return Container(
      margin: EdgeInsets.only(left: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RoundCheckbox(
            onChange: onChange,
            checked: checked,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
