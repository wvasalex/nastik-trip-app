import 'dart:async';
import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget {
  final bool active;

  ProgressBar({
    this.active = true,
  });

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  final Duration _duration = Duration(milliseconds: 1200);

  Timer _timer;

  bool _expanded = false;

  @override
  void initState() {
    _timer = Timer.periodic(_duration, (Timer timer) {
      _toggle();
    });
    Timer(Duration.zero, () {
      _toggle();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: _bar$(context),
        ),
        Positioned(
          child: _progress$(context),
        ),
      ],
    );
  }

  Widget _bar$(BuildContext context) {
    return Container(
      height: 3,
      color: Color(0xFFBDBDBD),
    );
  }

  Widget _progress$(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AnimatedContainer(
      width: _expanded ? MediaQuery.of(context).size.width : 0,
      duration: _duration,
      color: theme.errorColor,
      height: 3,
      curve: Curves.easeInOut,
    );
  }

  void _toggle() {
    setState(() {
      _expanded = widget.active ? !_expanded : false;
    });
  }
}
