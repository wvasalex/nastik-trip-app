import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final double size;
  final Color color;
  final String label;
  final Widget child;

  Avatar({
    @required this.size,
    @required this.color,
    this.label,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: child ?? Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    );
  }
}