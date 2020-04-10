import 'package:flutter/material.dart';

class StrokeText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final Color strokeColor;
  final double strokeWidth;
  final TextAlign textAlign;

  const StrokeText(
      this.text, {
        Key key,
        this.fontSize,
        this.fontWeight = FontWeight.bold,
        this.color = Colors.white,
        this.strokeColor = Colors.black,
        this.strokeWidth = .5,
        this.textAlign = TextAlign.center,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        Text(
          text,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            foreground: Paint()..color = color,
          ),
        ),
        Text(
          text,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            foreground: Paint()
              ..strokeWidth = strokeWidth
              ..color = strokeColor
              ..style = PaintingStyle.stroke,
          ),
        ),
      ],
    );
  }
}