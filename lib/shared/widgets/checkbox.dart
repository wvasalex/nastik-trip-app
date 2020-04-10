import 'package:flutter/material.dart';
import 'asset_icon.dart';

class CheckBox extends StatelessWidget {
  final Function onChange;
  final bool checked;
  final double size;
  final Widget label;

  CheckBox({
    @required this.onChange,
    @required this.checked,
    this.size = 20,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChange(!checked);
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _control$(context),
          SizedBox(width: 12),
          label ?? Container(),
        ],
      ),
    );
  }

  Widget _control$(BuildContext context) {
    return _indicator$(context);
  }

  Widget _indicator$(BuildContext context) {
    if (checked) {
      return AssetIcon(
        name: 'common/checkbox_checked',
        width: size,
        height: size,
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Color(0xFF323132),
        ),
      ),
    );
  }
}

class RoundCheckbox extends StatelessWidget {
  final Function onChange;
  final bool checked;
  final Color color;
  final double size;
  final bool underline;

  RoundCheckbox({
    @required this.onChange,
    @required this.checked,
    this.color = const Color(0xFF0043EE),
    this.size = 12,
    this.underline = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChange,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            width: underline ? 2 : 0,
            color: Colors.black,
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
        color: color,
      ),
    );
  }

  static wrap({
    @required Widget child,
    @required Function onChange,
    @required bool checked,
    bool disabled = false,
    bool underline = true,
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
            underline: underline,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
