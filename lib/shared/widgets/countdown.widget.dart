import 'dart:async';
import 'package:flutter/material.dart';

class Countdown extends StatefulWidget {
  final int timeout;
  final Function onTimeout;
  final Function getText;

  Countdown({
    @required this.timeout,
    @required this.onTimeout,
    @required this.getText,
  });

  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  Timer _timer;
  int _time;

  @override
  void initState() {
    _start();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.getText(_time),
    );
  }

  void _start() {
    setState(() {
      _time = widget.timeout;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (--_time == 0) {
          widget.onTimeout();
        }
      });
    });
  }
}
