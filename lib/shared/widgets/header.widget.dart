import 'package:flutter/material.dart';
import 'badge.dart';

class Header extends StatelessWidget {
  static final Color textColor = Color(0xFF323132);

  final String text;
  final TextStyle textStyle;
  final TextAlign align;
  final String badge;

  Header({
    @required this.text,
    @required this.textStyle,
    this.align,
    this.badge = '',
  });

  Header.title({
    @required this.text,
    this.align,
    this.badge = '',
  }) : this.textStyle = TextStyle(
          fontSize: 26,
          height: 30 / 36,
          color: Header.textColor,
          fontWeight: FontWeight.bold,
        );

  @override
  Widget build(BuildContext context) {
    if (badge.length == 0) {
      return Text(
        text,
        style: textStyle,
        textAlign: align ?? TextAlign.start,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          text,
          style: textStyle,
          textAlign: align ?? TextAlign.start,
        ),
        Badge(
          text: badge,
          color: Colors.red,
          margin: EdgeInsets.only(left: 8),
        ),
      ],
    );
  }
}
