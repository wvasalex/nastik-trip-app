import 'package:flutter/material.dart';
import 'rotation.widget.dart';
import 'asset_icon.dart';

class Button extends StatelessWidget {
  final Function onPressed;
  final String text;
  final bool disabled;
  final double width;
  final double borderRadius;
  final EdgeInsets margin;
  final bool progress;
  final Color color;

  Button({
    @required this.onPressed,
    @required this.text,
    this.disabled = false,
    this.width = double.infinity,
    this.borderRadius = 4,
    this.margin = const EdgeInsets.all(0),
    this.progress = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: width,
      margin: margin,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        onPressed: disabled || progress ? null : onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _progress$(context),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                text,
                style: theme.textTheme.body1.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        color: color ?? theme.primaryColor,
        textColor: Colors.white,
        disabledColor: theme.primaryColor.withOpacity(.85),
      ),
    );
  }

  Widget _progress$(BuildContext context) {
    if (!progress) {
      return Container();
    }

    return Container(
      margin: EdgeInsets.only(right: 8),
      child: Rotation(
        child: AssetIcon(
          name: 'common/round_progress.svg',
          color: Colors.white,
          height: 24,
        ),
      ),
    );
  }
}
