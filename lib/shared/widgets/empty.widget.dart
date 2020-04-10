import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  final String title;
  final String description;
  final Widget button;

  Empty({
    @required this.title,
    @required this.description,
    this.button,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.subhead,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          button ?? Container(),
          SizedBox(height: 48),
        ],
      ),
    );
  }
}
