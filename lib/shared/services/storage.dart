import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;

  Future<SharedPreferences> _prefs;

  LocalStorage._internal() {
    _prefs = SharedPreferences.getInstance();
  }

  Future<bool> setItem(String key, String value) async {
    return (await _prefs).setString(key, value);
  }

  Future<dynamic> getItem(String key) async {
    return (await _prefs).getString(key);
  }

  Future<bool> setInt(String key, int value) async {
    return (await _prefs).setInt(key, value);
  }

  Future<dynamic> getInt(String key) async {
    return (await _prefs).getInt(key);
  }
}