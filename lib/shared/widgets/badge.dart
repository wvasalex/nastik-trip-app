import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String text;
  final Color color;
  final TextStyle textStyle;
  final EdgeInsets margin;
  final EdgeInsets padding;

  Badge({
    this.child,
    this.text,
    this.textStyle,
    this.color = Colors.white,
    this.margin = const EdgeInsets.only(left: 4),
    this.padding = const EdgeInsets.all(6),
  }) : assert(child != null || text != null);

  Badge.success({
    this.child,
    this.text,
    this.textStyle,
    this.margin = const EdgeInsets.only(left: 4),
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  }) : color = const Color(0xFF27AE60);

  Badge.error({
    this.child,
    this.text,
    this.textStyle,
    this.margin = const EdgeInsets.only(left: 4),
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  }) : color = const Color(0xFFEA2434);

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration = BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    );

    if (text == null || text.length > 1) {
      decoration = decoration.copyWith(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
      );
    }

    return Container(
      decoration: decoration,
      margin: margin,
      padding: padding,
      child: _child$(context),
    );
  }

  Widget _child$(BuildContext context) {
    if (child != null) {
      return child;
    }

    return Text(
      text ?? '',
      style: (textStyle ?? Theme.of(context).textTheme.body2).copyWith(
        height: 1,
        color: Colors.white,
      ),
    );
  }
}
