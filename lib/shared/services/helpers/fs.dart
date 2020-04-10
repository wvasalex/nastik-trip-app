import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FS {
  factory FS() => _instance;

  static final FS _instance = FS._internal();

  Future<Directory> _dirResolver;

  FS._internal() {
    _dirResolver = getApplicationDocumentsDirectory();
    createDirectory('data');
  }

  Future<String> createDirectory(String path) async {
    final String dirname = await resolve(path);
    await Directory(dirname).create(recursive: true);
    return dirname;
  }

  Future<List<String>> readDirectory(
      String path, {
        bool files = true,
        bool dirs = false,
      }) async {
    final Directory dir = Directory(await resolve(path));

    return readDirectorySync(
      await resolve(path),
      files: files,
      dirs: dirs,
    );
  }

  List<String> readDirectorySync(
      String path, {
        bool files = true,
        bool dirs = false,
      }) {
    final Directory dir = Directory(path);
    final List contents = dir.existsSync() ? dir.listSync() : [];
    final List<String> result = [];
    for (var file in contents) {
      if (file is File && files) {
        result.add(file.path);
      } else if (file is Directory && dirs) {
        result.add(file.path);
      }
    }

    return result;
  }

  Future deleteDirectory(String path) async {
    final Directory dir = Directory(await resolve(path));
    return dir.existsSync() ? dir.delete(recursive: true) : true;
  }

  Future deleteFile(String path) async {
    String filename = await resolve(path);
    final File file = File(filename);
    return file.existsSync() ? file.delete(recursive: true) : true;
  }

  String basename(String path) {
    return p.basename(path);
  }

  Future<String> resolve(String path) async {
    final Directory dir = await _dirResolver;
    if (path.indexOf(dir.path) == -1) {
      return '${dir.path}/data/$path';
    }
    return path;
  }

  String getContent(String filename) {
    final File file = File(filename);
    return file.existsSync() ? file.readAsStringSync() : null;
  }

  Future<File> putContent(String filename, String content) async {
    final File file = File(filename);
    return file.writeAsString(content);
  }

  dynamic readJSON(String filename) {
    final String content = getContent(filename);
    if (content == null) {
      return null;
    }
    try {
      return json.decode(content);
    } catch (e) {
      return null;
    }
  }
}
