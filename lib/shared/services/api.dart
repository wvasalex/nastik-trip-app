import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'auth/auth.service.dart';
import 'cache.dart';
import 'device_info.dart';

class ApiError {
  final int errorCode;

  ApiError(this.errorCode);

  ApiError.fromJSON(Map<String, dynamic> raw) : errorCode = raw['error_code'];

  String toString() {
    return 'ApiError #$errorCode';
  }
}

class ApiService {
  factory ApiService() => _instance;
  static final ApiService _instance = ApiService._();

  ApiService._() {
    DeviceInfo().getInfo().then((Map<String, String> info) {
      _deviceInfo = info;
    });
  }

  static const _host = 'https://madirect.millionagents.com';
  static const _m54 = 'https://m54.millionagents.com';

  final Cache _cache = Cache();

  Map<String, String> _deviceInfo;

  String _getHost(bool m54) {
    return m54 ? _m54 : _host;
  }

  Future<dynamic> get(
    String url, {
    String contentType,
    String token,
    String responseType,
    bool cache = false,
    bool forceCache = false,
    bool m54 = false,
  }) async {
    final String cacheKey = url;

    if (cache && !forceCache) {
      final String cached = await _cache.get(cacheKey);
      if (cached != null) {
        return json.decode(cached);
      }
    }

    final Function request = () {
      return http.get(
        _getHost(m54) + url,
        headers: _withToken(
          token,
          {
            'Content-Type': contentType != null
                ? contentType
                : 'application/json; charset=utf-8',
            'responseType': 'blob',
          },
        ),
      );
    };

    return request().then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        if (response.body is String && response.body.length > 0) {
          throw ApiError.fromJSON(json.decode(response.body));
        } else {
          throw ApiError(0);
        }
      }
      if (contentType == null) {
        if (cache) {
          _setCache(cacheKey, response.body);
        }
        return json.decode(response.body);
      }
      return response.bodyBytes;
    });
  }

  Future<dynamic> post(
    String url, {
    Map body,
    String token,
    String contentType,
    bool raw = true,
    bool cache = false,
    bool forceCache = false,
    bool m54 = false,
  }) async {
    final String cacheKey = url + (body != null ? json.encode(body) : '');

    if (cache && !forceCache) {
      final String cached = await _cache.get(cacheKey);
      if (cached != null) {
        final Map decoded = json.decode(cached);
        return raw ? decoded : decoded['result'];
      }
    }

    final Function request = () {
      return http.post(
        _getHost(m54) + url,
        headers: _withToken(token, {
          'Content-Type': contentType != null
              ? contentType
              : 'application/json; charset=utf-8',
        }),
        body: json.encode(body),
      );
    };

    return request().then((http.Response response) {
      final int statusCode = response.statusCode;
      print(
          '${_getHost(m54) + url} ${json.encode(body)} completed with status $statusCode ${response.body}');
      if (statusCode < 200 || statusCode > 400) {
        if (response.body is String && response.body.length > 0) {
          throw ApiError.fromJSON(json.decode(response.body));
        } else {
          throw ApiError(0);
        }
      }
      if (cache) {
        _setCache(cacheKey, response.body);
      }

      final Map decoded = json.decode(response.body);
      return raw ? decoded : decoded['result'];
    });
  }

  Future<dynamic> sendFile({
    @required String url,
    @required String filename,
    @required Function getData,
    Function(FormData, UploadFileInfo) prepare,
    String token,
    bool m54 = false,
  }) async {
    final file = filename != null
        ? UploadFileInfo.fromBytes(
            await File(filename).readAsBytes(),
            basename(filename),
          )
        : [];

    FormData body = FormData.from(getData(file));
    if (prepare != null) {
      body = prepare(body, file);
    }

    final Dio dio = Dio();

    return dio
        .post(
      _getHost(m54) + url,
      data: body,
      options: Options(
        headers: _withToken(token, {
          'Content-Type': 'multipart/form-data',
        }),
      ),
    )
        .catchError((e) {
      throw ApiError(e.response.data['error_code']);
    }).then((Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400) {
        throw ApiError.fromJSON(json.decode(response.data));
      }
      return response.data['result'];
    });
  }

  Future<dynamic> delete(
    String url, {
    String token,
  }) {
    return _handlerError(http.delete(
      _host + url,
      headers: _withToken(token, {
        'Content-Type': 'application/json; charset=utf-8',
      }),
    ));
  }

  Future<dynamic> put(
    String url, {
    Map<String, dynamic> body,
    String token,
  }) {
    return _handlerError(http.put(
      _host + url,
      body: json.encode(body),
      headers: _withToken(token, {
        'Content-Type': 'application/json; charset=utf-8',
      }),
    ));
  }

  Future _handlerError(Future<http.Response> request) {
    return request.then((http.Response response) {
      final int statusCode = response.statusCode;
      final Map result = json.decode(response.body);

      if (statusCode < 200 || statusCode > 400) {
        throw ApiError.fromJSON(result);
      }
      return result;
    });
  }

  String _getToken(String token) {
    return token ?? AuthService().getToken();
  }

  Map<String, String> _withToken(
    String passedToken,
    Map<String, String> headers,
  ) {
    String token = _getToken(passedToken);
    headers['Authorization'] = 'Token $token';

    if (_deviceInfo != null) {
      headers['X-APP-VERSION'] = _deviceInfo['app_version'];
      headers['X-APP-NAME'] = _deviceInfo['app_identifier'];
    }

    return headers;
  }

  _setCache(String cacheKey, String value) {
    _cache.set(cacheKey, value);
  }
}
