import 'package:flutter/material.dart';
import 'package:journey/shared/widgets/stroke_text.widget.dart';

class SAppBar extends AppBar {
  final String label;
  final Widget secondary;
  final List<Widget> actions;
  final bool back;
  final Color backColor;
  final Function onTap;
  final Function onBack;
  final double borderWidth;
  final Color backgroundColor;
  final double elevation;
  final Color labelColor;

  SAppBar({
    this.label = '',
    this.secondary,
    this.back,
    this.onTap,
    this.onBack,
    this.actions,
    this.backColor = const Color(0xFFEA2434),
    this.borderWidth = 0,
    this.backgroundColor = Colors.transparent,
    this.elevation = 0,
    this.labelColor,
  }) : super(
          leading: back == true
              ? FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: onBack,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: backColor,
                    size: 24,
                  ),
                  shape: CircleBorder(),
                )
              : null,
          title: _title$(label, secondary, onTap, labelColor),
          centerTitle: true,
          elevation: elevation,
          backgroundColor: backgroundColor,
          actions: actions,
          bottom: PreferredSize(
            child: Container(
              color: Color(0XFFBDBDBD).withOpacity(.5),
              height: borderWidth,
            ),
            preferredSize: Size.fromHeight(borderWidth),
          ),
          automaticallyImplyLeading: false,
        );

  static Widget _title$(
      String label, Widget secondary, Function onTap, Color labelColor) {
    final Widget title = StrokeText(
      label,
      fontSize: 18,
      color: labelColor ?? Color(0xFF323132),
      strokeColor: Colors.white,
      strokeWidth: .3,
    );

    if (secondary == null) {
      return title;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            title,
            secondary,
          ],
        ),
      ),
    );
  }
}
