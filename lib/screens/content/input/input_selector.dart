import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:journey/shared/shared.dart';
import 'input_selector_controller.dart';

export 'input_selector_controller.dart';

class InputSelector extends StatefulWidget {
  final Function(String) onSelect;
  final InputSelectorController controller;

  InputSelector({
    @required this.onSelect,
    this.controller,
  });

  @override
  _InputSelectorState createState() => _InputSelectorState();
}

class _InputSelectorState extends State<InputSelector>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  InputSelectorController _controller;

  static const Map<String, IconData> _actions = {
    'camera': Icons.camera_alt,
    'text': Icons.edit,
  };

  @override
  void initState() {
    _controller = widget.controller ?? InputSelectorController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _controller.addListener(() {
      if (_controller.opened) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _overlay$(context),
        Positioned(
          bottom: 0,
          right: 0,
          child: _fab$(context),
        ),
      ],
    );
  }

  Widget _fab$(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<Widget> items = _actions.keys.map(_action$).toList();

    items.add(
      FloatingActionButton(
        backgroundColor: theme.errorColor,
        heroTag: 'fab',
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget child) {
            return Transform(
              transform:
                  Matrix4.rotationZ(_animationController.value * math.pi * .5),
              alignment: FractionalOffset.center,
              child: Icon(
                _controller.opened ? Icons.close : Icons.add,
                color: Colors.white,
                size: 36,
              ),
            );
          },
        ),
        onPressed: _toggle,
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: items,
    );
  }

  Widget _action$(String action) {
    final int index = _actions.keys.toList().indexOf(action);

    return Container(
      height: 48.0,
      width: 48.0,
      margin: EdgeInsets.only(bottom: 12),
      alignment: FractionalOffset.topCenter,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.0,
            1.0 - index / _actions.length / 1.0,
            curve: Curves.easeOut,
          ),
        ),
        child: FloatingActionButton(
          heroTag: action,
          backgroundColor: Colors.white,
          child: Icon(
            _actions[action],
            color: Colors.black,
          ),
          onPressed: () {
            _handle(action);
          },
        ),
      ),
    );
  }

  Widget _overlay$(BuildContext context) {
    if (!_controller.opened) {
      return Container();
    }

    return Positioned.fill(
      child: GestureDetector(
        onTap: _toggle,
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }

  void _toggle() {
    setState(() {
      _controller.toggle();
    });
  }

  void _handle(String action) {
    _toggle();
    widget.onSelect(action);
  }
}
