import 'package:flutter/material.dart';

class InputSelectorController extends ChangeNotifier {
  bool opened = false;

  void open() {
    opened = true;
    notifyListeners();
  }

  void close() {
    opened = false;
    notifyListeners();
  }

  void toggle() {
    opened ?
        close() :
        open();
  }
}