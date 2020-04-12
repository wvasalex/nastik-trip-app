import 'package:flutter/material.dart';
import 'package:journey/shared/shared.dart';

abstract class InputBase extends StatefulWidget {
  final Function() onCancel;
  final Function(String) onChange;
  final Function() onRemove;
  final String path;
  final int date;

  InputBase({
    @required this.onCancel,
    @required this.onChange,
    @required this.onRemove,
    @required this.path,
    @required this.date,
    Key key,
  }) : super(key: key);

  Widget cancel$(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: onCancel,
      child: Text(
        'Отменить',
        style: theme.textTheme.body1.copyWith(
          color: theme.primaryColor,
        ),
      ),
    );
  }

  Widget preview$({BuildContext context, Widget child}) {
    final ThemeData theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: theme.errorColor.withOpacity(.05),
            blurRadius: 4.0,
            spreadRadius: 2.0,
            offset: Offset(2, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 12,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: child,
          ),
          _remove$(context),
        ],
      ),
      /*child: Column(
        children: <Widget>[
          child,
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                Helpers.date(
                  date: date ?? 0,
                  format: 'H:mm',
                  ms: 1,
                ),
                style: theme.textTheme.body2,
              ),
              _remove$(context),
            ],
          ),
        ],
      ),*/
    );
  }

  Widget _remove$(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return RoundButton(
      onPressed: onCancel,
      child: Icon(
        Icons.close,
        size: 16,
      ),
    );
  }
}
