import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:journey/shared/shared.dart';

final FS fs = FS();

class Content {
  final int id;
  final String uuid;
  final bool readonly;
  final String state;
  final String reason;
  final String comment;
  String title;
  List<ContentValueItem> value;

  static Map<String, String> _rejected = {
    'invalid_availability': 'Неверно указано наличие товара',
    'poor_quality_photo': 'Плохое качество фото',
    'invalid_article': 'Собран неверный товар',
  };

  static const String fsRoot = 'content';

  Content({
    @required this.id,
    @required this.title,
    @required this.value,
    this.readonly = false,
    this.state,
    this.reason,
    this.comment,
  }) : uuid = Uuid().v4();

  Content.fromJSON(Map<String, dynamic> raw)
      : id = raw['id'],
        value = null,
        readonly = true,
        state = getState(raw['state']),
        reason = getReason(raw['state']),
        comment = raw['comment'],
        uuid = '';

  Content.empty({
    int id,
  })  : id = id ?? Helpers.localTime(),
        title = '',
        value = [],
        readonly = false,
        state = null,
        reason = null,
        comment = null,
        uuid = null;

  static String getState(String state) {
    if (_rejected.containsKey(state)) {
      state = 'rejected';
    }
    return state;
  }

  static String getReason(String state) {
    if (_rejected.containsKey(state)) {
      return _rejected[state];
    }
    return null;
  }

  String getPath() {
    return '$fsRoot/$id';
  }

  Future<String> getValuePath() {
    return fs.resolve(getPath() + '/value.json');
  }

  Future save() async {
    final String valuePath = await getValuePath();

    fs.putContent(
      valuePath,
      toString(),
    );
  }

  String toString() {
    return json.encode({
      'title': title,
      'value': value.map((ContentValueItem item) {
        return item.toMap();
      }).toList(),
    });
  }

  void read() async {
    final Map raw = fs.readJSON(await getValuePath());

    title = raw['title'];
    value = List.from(raw['value'].map((answer) => ContentValueItem.fromJSON(answer)));
  }
}

class ContentValueItem {
  final String type;
  final String value;
  final int performTime;
  final double lat;
  final double lon;

  ContentValueItem({
    @required this.type,
    @required this.value,
    @required this.performTime,
    @required this.lat,
    @required this.lon,
  });

  ContentValueItem.fromJSON(Map<String, dynamic> raw)
      : type = raw['type'],
        value = raw['value'],
        performTime = raw['perform_time'],
        lat = raw['lat'],
        lon = raw['lon'];

  Map toMap() {
    return {
      'type': type,
      'value': value,
      'perform_time': performTime,
      'lat': lat,
      'lon': lon,
    };
  }
}