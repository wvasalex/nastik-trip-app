import 'package:flutter/material.dart';

class ToasterService {
  static final ToasterService _instance = ToasterService._internal();

  factory ToasterService() => _instance;

  ToasterService._internal();

  List<GlobalKey<ScaffoldState>> _scaffolds = [];

  void setCurrentScaffold(GlobalKey<ScaffoldState> scaffoldKey) {
    if (!_scaffolds.contains(scaffoldKey)) {
      _scaffolds.add(scaffoldKey);
    }
  }

  void toast(
    String content, {
    Color backgroundColor = const Color(0xFF323132),
    TextStyle textStyle,
  }) {
    _scaffolds.removeWhere((GlobalKey<ScaffoldState> key) {
      return key.currentState == null;
    });

    _scaffolds.last.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 1),
        backgroundColor: backgroundColor,
        content: Text(
          content,
          style: textStyle,
        ),
      ),
    );
  }

  void error(String content) {
    return toast(
      content,
      backgroundColor: Color(0xFFEA2434),
      textStyle: TextStyle(
        fontSize: 11,
        height: 14 / 11,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
