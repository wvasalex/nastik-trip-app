import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:random_string/random_string.dart' as random;
import 'connection.dart';

class WsService {
  static const _host = 'wss://office.millionagents.com/ws';

  static final WsService _instance = WsService._internal();

  factory WsService() => _instance;

  Function auth;

  final Connection _connection = Connection();
  WebSocketChannel _channel;
  Map<String, dynamic> _pending = {};
  Map<String, List<Function>> _handlers = {};
  List<Function> _onConnect = [];

  List<StreamSubscription> _subs = [];

  WsService._internal() {
    Timer(Duration(microseconds: 300), _connect);
  }

  void dispose() {
    _subs.forEach((StreamSubscription sub) {
      sub.cancel();
    });
  }

  Stream init(String token) {
    return send('auth', {'token': token});
  }

  Stream send(String method, params, {Function handleData}) {
    WsRequest req = WsRequest(
      method: method,
      params: params,
    );

    if (_channel == null) {
      _onConnect.add(() {
        _channel.sink.add(req.toString());
      });
    } else {
      _channel.sink.add(req.toString());
    }

    _pending[req.id] = StreamController<dynamic>();
    return _pending[req.id].stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          if (handleData != null) {
            data = handleData(data);
          }
          sink.add(data);
        },
      ),
    );
  }

  void addHandler(String method, Function handler) {
    if (_handlers[method] == null) {
      _handlers[method] = [];
    }
    _handlers[method].add(handler);
  }

  void _connect() {
    if (_channel != null) {
      return;
    }

    dispose();
    _channel = IOWebSocketChannel.connect(WsService._host);
    _subs.add(_channel.stream.listen(_onMessage, onDone: () async {
      _channel = null;
      final hasConnection = await _connection.checkConnection();
      if (hasConnection) {
        _connect();
      }
    }));

    _subs.add(_connection.connectionChange.listen((hasConnection) {
      if (hasConnection && _channel == null) {
        _connect();
      }
    }));

    if (auth != null) {
      auth();
    }

    if (_onConnect.length > 0) {
      _onConnect.forEach((Function handler) {
        handler();
      });
      _onConnect = [];
    }
  }

  void _onMessage(message) {
    WsResponse resp = WsResponse.fromJSON(json.decode(message));
    if (_pending.containsKey(resp.id)) {
      StreamController stream = _pending[resp.id];
      if (resp.ok == false) {
        stream.addError(resp);
      } else {
        stream.add(resp.result);
      }
      stream.close();
      _pending.remove(resp.id);
    }

    var handlers = _handlers[resp.method];
    if (handlers != null) {
      handlers.forEach((Function handler) {
        handler(resp.result);
      });
    }
  }
}

class WsRequest {
  String id;
  final String method;
  final params;

  WsRequest({@required this.method, @required this.params}) {
    id = method + random.randomNumeric(8);
  }

  String toString() {
    return json.encode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'method': method,
      'params': params,
    };
  }
}

class WsResponse {
  final String id;
  final bool ok;
  final result;
  final String method;
  final int errorCode;

  WsResponse({
    @required this.id,
    @required this.ok,
    @required this.result,
    this.method,
    this.errorCode,
  });

  static fromJSON(Map<String, dynamic> raw) {
    return WsResponse(
      id: raw['id'],
      ok: raw['ok'],
      result: raw['result'] ?? raw['params'],
      method: raw['method'],
      errorCode: raw['error_code'],
    );
  }
}
