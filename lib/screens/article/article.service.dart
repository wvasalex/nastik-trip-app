import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:journey/shared/shared.dart';
import 'article.model.dart';

export 'article.model.dart';

class ArticleService {
  final ApiService api = ApiService();
  final FS fs = FS();

  Future<List<Article>> get() async {
    // return api.get('http://nastik-trip.com/api/content');

    final List<String> dirs = await fs.readDirectory(
      await _path(),
      dirs: true,
      files: false,
    );

    return dirs.map((String path) {
      var raw = fs.readJSON('$path/article.json');
      return Article.fromJSON(raw, _getImages(path));
    }).toList();
  }

  Future<Article> getById(int id) async {
    final String path = (await _path()) + '/$id';
    var raw = fs.readJSON('$path/article.json');
    return Article.fromJSON(raw, _getImages(path));
  }

  Future save(Article article) async {
    final String path = (await _path()) + '/${article.id}';
    await fs.createDirectory(path);
    return fs.putContent('$path/article.json', article.toJSON());
  }

  Future<String> addImage(int id, File image) async {
    return _addMedia(id, image, '.jpg');
  }

  Future<String> addVideo(int id, File video) async {
    return _addMedia(id, video, path.extension(video.path));
  }
  
  Future<String> _addMedia(int id, File image, String ext) async {
    final String path = (await _path()) + '/$id';
    await fs.createDirectory(path);
    final int imageId = DateTime.now().millisecondsSinceEpoch;

    image.copy('$path/$imageId$ext');
    return '$path/$imageId$ext';
  }

  void deleteImage(String imagePath) {
    fs.deleteFile(imagePath);
  }

  void delete(int id) async {
    final String path = (await _path()) + '/$id';
    await fs.deleteDirectory(path);
  }

  List<String> _getImages(String path) {
    final List<String> files = fs.readDirectorySync(
      path,
      dirs: false,
      files: true,
    );

    List<String> images = files.where((String filename) {
      return !filename.contains('.json');
    }).toList();
    images.sort();
    return images;
  }

  Future<String> _path() {
    return fs.createDirectory('article');
  }
}
