import 'helpers/helpers.dart';

class Cache {
  factory Cache() => _instance;
  static final Cache _instance = Cache._internal();
  Cache._internal();

  static final FS _fs = FS();
  Future<String> _path = _fs.createDirectory('cache');
  final Map<String, String> _data = {};

  void clear() {
    _fs.deleteDirectory('cache');
    _path = _fs.createDirectory('cache');
    _data.clear();
  }

  Future set(String key, String value) async {
    _data[key] = value;
    _fs.putContent(await _resolvePath(key), value);
  }

  Future<String> get(String key) async {
    if (_data.containsKey(key)) {
      return _data[key];
    }

    return _data[key] = _fs.getContent(await _resolvePath(key));
  }

  void remove(String key) async {
    _data.remove(key);
    _fs.deleteFile(await _resolvePath(key));
  }

  Future<String> _resolvePath(String key) async {
    key = key.replaceAll('/', '_');
    if (!key.startsWith('/')) {
      key = '/$key';
    }
    return (await _path) + key;
  }
}