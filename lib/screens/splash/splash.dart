import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:journey/shared/shared.dart';

class Splash extends StatefulWidget {
  static const routeName = 'splash';

  final Function() onStart;

  Splash({
    @required this.onStart,
  });

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  AnimationController _animationController;

  static const List<String> _texts = ['Планы', 'Заметки', 'Покупки', 'Все просто!'];
  int _index = 0;
  String _label = _texts[0];

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        if (_index < _texts.length - 1) {
          _label = _texts[++_index];
          _animationController.forward(from: 0);

          setState(() {});
        }
      }
    });
    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Page(
      body: GestureDetector(
        onTap: widget.onStart,
        child: Container(
          decoration: BoxDecoration(
            color: theme.primaryColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(),
              _label$(context),
            ],
          ),
        ),
      ),
      margin: EdgeInsets.all(0),
      floatingActionButton: Container(),
    );
  }

  Widget _label$(BuildContext context) {
    return ScaleTransition(
      scale: _animationController,
      child: StrokeText(
        _label,
        fontSize: 80,
        color: Colors.white,
      ),
    );
  }
}
