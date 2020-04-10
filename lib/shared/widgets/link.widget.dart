import 'package:flutter/material.dart';
import '../services/navigate.dart';

class Link extends StatelessWidget {
  final String text;
  final Function to;
  final TextStyle textStyle;

  Link({
    @required this.text,
    @required this.to,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigate.push(
          context: context,
          widget: to(),
        );
      },
      child: Text(
        text,
        style: textStyle ?? theme.textTheme.body2.copyWith(
          color: theme.primaryColor,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
