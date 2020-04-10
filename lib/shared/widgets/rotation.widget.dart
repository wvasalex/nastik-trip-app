import 'package:flutter/material.dart';

class Rotation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  Rotation({
    this.child,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  _RotationState createState() => _RotationState();
}

class _RotationState extends State<Rotation> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
      child: widget.child,
    );
  }
}
