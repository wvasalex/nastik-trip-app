import 'package:flutter/material.dart';

class SharedList<T> extends ChangeNotifier {
  List<T> _items;

  int get length => _items.length;

  List<T> get value => _items;

  SharedList({
    List<T> initialValue = const [],
  }) : _items = initialValue;

  List<T> setValue(List<T> newValue) {
    this._items = newValue;
    notifyListeners();
    return newValue;
  }

  int add(T item) {
    _items.add(item);
    notifyListeners();
    return _items.length;
  }

  int insert(int index, T item) {
    _items.insert(index, item);
    notifyListeners();
    return _items.length;
  }

  int remove(T item) {
    _items.remove(item);
    notifyListeners();
    return _items.length;
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  int indexOf(T item) {
    return _items.indexOf(item);
  }

  T elementAt(int index) {
    return _items.elementAt(index);
  }
}
