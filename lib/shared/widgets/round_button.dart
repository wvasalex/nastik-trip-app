import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final Function onPressed;
  final Widget child;
  final Color color;
  final double size;
  final bool disabled;
  final double elevation;

  RoundButton({
    @required this.child,
    @required this.onPressed,
    this.size = 32,
    this.color,
    this.disabled = false,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: size,
      height: size,
      child: Center(
        child: RawMaterialButton(
          onPressed: disabled ? null : onPressed,
          child: SizedBox(
            width: size,
            height: size,
            child: child,
          ),
          shape: CircleBorder(),
          splashColor: theme.errorColor,
          elevation: elevation,
          fillColor: color,
        ),
      ),
    );
  }
}
