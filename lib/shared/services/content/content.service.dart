import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:uuid/uuid.dart';
import '../../shared.dart';
import 'content.model.dart';
export 'content.model.dart';

class ContentService {
  static final ContentService _instance = ContentService._internal();

  factory ContentService() => _instance;

  ContentService._internal();

  final FS fs = FS();
  final ApiService apiService = ApiService();
  final ToasterService _toaster = ToasterService();
  final Connection _connection = Connection();

  final List<int> _pending = [];

  Future<List<Content>> getSentContents({int page = 1, int limit = 100}) {
    return apiService
        .get('/api/agents/v2/reports?page=$page&per_page=$limit')
        .then((data) {
      return List.from(data['reports']).map((report) {
        return Content.fromJSON(report);
      }).toList();
    });
  }

  void deleteAll() {
    fs.deleteDirectory('content');
  }

  Future<List<Content>> getArticles() async {
    List<String> ids = await fs.readDirectory(
      'content',
      files: false,
      dirs: true,
    );

    var resolvers = ids.map((String path) {
      return getContent(int.parse(fs.basename(path)));
    }).toList();

    return Future.wait(resolvers);
  }

  Future<Content> createContent() async {
    final Content content = Content.empty();
    content.value.add(ContentValueItem(type: 'text',
        value: '',
        performTime: Helpers.localTime(),
    ));
    await
    fs.createDirectory(content.getPath());

    return content;
  }

  Future<Content> getContent(int id) async {
    return Content.empty(id: id)
      ..read();
  }

  Future<bool> sendContent(Content report, {
    Function onCreated,
    Function onFileUpload,
    Function onCheckStart,
    Function onComplete,
    Function onError,
  }) async {
    if (_pending.indexOf(report.id) != -1) {
      return null;
    }

    _pending.add(report.id);

    final String reportJson = report.toString();
    final String uid = Uuid().v4();
    final Function failure = () {
      _pending.remove(report.id);
      if (onError != null) {
        onError();
      }
      return false;
    };
    Map<String, dynamic> data;
    int id;

    //final _report = await _getContentByUid(report.id, report.task);

    try {
      data = await apiService.post('/api/reports/upload', body: {
        'id': report.id,
        'report_json': reportJson,
      });

      if (data == null || data['id'] == null) {
        throw '';
      }
      id = data['id'];
    } catch (e) {
      return failure();
    }

    try {
      await _sendFiles(
        id,
        report,
        onUpload: onFileUpload,
      );
    } catch (e) {
      return failure();
    }

    if (onCheckStart != null) {
      onCheckStart();
    }

    final Function done = () {
      _pending.remove(report.id);
      if (onComplete != null) {
        onComplete();
      }
    };

    checkContent(
      id,
      onComplete: done,
      onError: failure,
    );
  }

  void checkContent(int reportId, {Function onComplete, Function onError}) {
    Timer timer;
    Function check = () {
      _checkContent(reportId).then((result) {
        if (result['state'] == 'completed') {
          if (timer != null) {
            timer.cancel();
          }
          if (onComplete != null) {
            if (onComplete() != false) {
              _toaster.toast('Отчет успешно отправлен!');
            }
          }
        }
      }).catchError((_) {
        if (onError != null) {
          onError();
        }
      });
    };

    check();
    timer = Timer.periodic(Duration(seconds: 10), (_) {
      check();
    });
  }

  Future _checkContent(int reportId) {
    return apiService.post(
      '/api/reports/check_state',
      body: {
        'report_id': reportId,
      },
    );
  }

  Future _sendFiles(int reportId,
      Content report, {
        Function onUpload,
      }) async {
    final int uid = report.id;

    final String path = await fs.createDirectory('reports/$uid');
    final String sentFilesStorage = await fs.resolve('$path/__files.json');

    List sentFiles = [];
    int index = 0;

    if (File(sentFilesStorage).existsSync()) {
      sentFiles = fs.readJSON(sentFilesStorage) ?? [];
    }

    final Function onFileSent = (String filename) async {
      if (!sentFiles.contains(filename)) {
        sentFiles.add(filename);
        fs.putContent(sentFilesStorage, json.encode(sentFiles));
      }
    };

    final Function send = (String filename, int total) {
      /** File was sent before */
      if (sentFiles.contains(filename)) {
        print('File $filename was already uploaded to $reportId');
        if (onUpload != null && index < total) {
          onUpload(++index, total);
        }
        return Future.value(true);
      }

      print('Upload $filename to $reportId');
      return apiService
          .sendFile(
        url: '/api/reports/upload_file',
        filename: filename,
        getData: (file) {
          return {
            'report_id': reportId,
            'file': file,
          };
        },
      )
          .then((data) {
        if (onUpload != null && index < total) {
          onUpload(++index, total);
        }
        onFileSent(filename);
        return data;
      });
    };

    /*final int total = files.length;
    final Completer<void> done = Completer();

    final Function sendQueue = () async {
      while (files.length > 0) {
        if (!_connection.hasConnection) {
          return;
        }

        try {
          await send(files[0], total);
          files.removeAt(0);
        } catch (e) {}
      }
      if (files.length == 0) {
        done.complete();
      }
    };

    StreamSubscription sub$;
    sub$ = _connection.connectionChange.listen((_) {
      if (_connection.hasConnection) {
        sendQueue();
      }
    });
    sendQueue();

    done.future.then((_) {
      sub$.cancel();
    });

    return done.future;*/

    return Future.value();
  }
}
