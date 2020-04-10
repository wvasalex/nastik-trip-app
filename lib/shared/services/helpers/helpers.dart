import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
export 'colors.dart';
export 'fs.dart';

class Helpers {
  static pluralize(int n, {String one, String two, String many}) {
    n %= 100;
    if (n >= 5 && n <= 20) {
      return many;
    }
    n %= 10;
    if (n == 1) {
      return one;
    }
    if (n >= 2 && n <= 4) {
      return two;
    }
    return many;
  }

  static String currency(double amount) {
    return NumberFormat.currency(
      symbol: 'P',
      locale: 'ru',
      decimalDigits: 2,
    ).format(amount);
  }

  static String date({int date, String format = 'd MMMM y, H:mm', int ms = 1000}) {
    final DateFormat _format = DateFormat(format);
    return _format.format(DateTime.fromMillisecondsSinceEpoch(date * ms));
  }

  static void copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  static int localTime([int milliseconds]) {
    final date = milliseconds != null ? DateTime.fromMillisecondsSinceEpoch(milliseconds) : null;
    final DateTime now = DateTime.now();
    return (date ?? now).add(now.timeZoneOffset).millisecondsSinceEpoch - 10800000;
  }

  static void printWrapped(dynamic data) {
    if (!(data is String)) {
      data = json.encode(data);
    }

    final RegExp pattern = RegExp('.{1,800}');
    pattern.allMatches(data).forEach((match) => print(match.group(0)));
  }

  static String fixPhone(String phone) {
    phone = phone.replaceAll('+', '');
    if (phone.startsWith('8')) {
      phone = phone.replaceFirst('8', '7');
    }
    return phone;
  }
}
