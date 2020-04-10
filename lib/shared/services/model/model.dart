class Model {
  Map<String, String> _value = {};
  List<Function> _listeners = [];

  void set(String key, String value) {
    _value[key] = value;
    _listeners.forEach((Function listener) {
      listener(_value, key, value);
    });
  }

  dynamic getValue([String key]) {
    if (key != null) {
      return _value[key];
    }

    return _value;
  }

  void reset() {
    _value.clear();
  }

  Function addListener(Function listener) {
    _listeners.add(listener);
    return () {
      _listeners.remove(listener);
    };
  }
}