import 'dart:async';
import 'package:flutter/material.dart';
import '../shared.dart';

class PullToDismiss extends StatefulWidget {
  final Widget child;

  PullToDismiss({
    @required this.child,
  });

  @override
  _PullToDismissState createState() => _PullToDismissState();
}

class _PullToDismissState extends State<PullToDismiss> {
  double _top = 0;
  double _opacity = 1;

  Duration _positionDuration = Duration.zero;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Page(
      //backgroundColor: Colors.white.withOpacity(1 - _opacity),
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: Duration(milliseconds: 120),
        child: GestureDetector(
          onPanEnd: (DragEndDetails end) {
            _check(context);
          },
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              _top += details.delta.dy;
              if (_top < 0) {
                _top = 0;
              }
              _opacity = 1 - _top / size.height;
            });
          },
          child: Stack(
            children: <Widget>[
              AnimatedPositioned(
                duration: _positionDuration,
                top: _top,
                width: size.width,
                height: size.height,
                child: widget.child,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(),
    );
  }

  void _check(BuildContext context) {
    _positionDuration = Duration(milliseconds: 240);
    if (_opacity > .9) {
      _top = 0;
      Timer(_positionDuration, () {
        _positionDuration = Duration.zero;
      });
    } else {
      _top = MediaQuery.of(context).size.height + 300;
      Timer(_positionDuration, () {
        Navigator.of(context).pop();
      });
    }

    setState(() {});
  }
}
