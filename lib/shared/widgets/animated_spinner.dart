import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedSpinner extends StatefulWidget {
  final Color color;
  final int itemCount;

  AnimatedSpinner({
    this.color,
    this.itemCount = 3,
  });

  @override
  _AnimatedSpinnerState createState() => _AnimatedSpinnerState();
}

class _AnimatedSpinnerState extends State<AnimatedSpinner> {
  int _activeIndex = 0;

  Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(new Duration(milliseconds: 300), (timer) {
      setState(() {
        if (++_activeIndex == widget.itemCount) {
          _activeIndex = 0;
        }
      });
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _item(0),
        _item(1),
        _item(2),
      ],
    );
  }

  Widget _item(int index) {
    final size = index == _activeIndex ? 8.0 : 4.0;
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      margin: EdgeInsets.only(left: 4),
      width: size,
      height: size,
      color: index == _activeIndex
          ? Colors.black
          : widget.color ?? Theme.of(context).primaryColor,
    );
  }
}
