import 'package:flutter/material.dart';

abstract class Navigate {
  static push({
    @required BuildContext context,
    @required Widget widget,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => widget),
    );
  }

  static Future setRoot({
    @required BuildContext context,
    @required Widget widget,
  }) {
    return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => widget),
      (_) => false,
    );
  }
}
