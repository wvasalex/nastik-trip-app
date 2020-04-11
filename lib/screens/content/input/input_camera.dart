import 'package:flutter/material.dart';
import 'package:journey/shared/shared.dart';

import 'input_base.dart';

class InputCamera extends InputBase {
  final String value;

  InputCamera({
    this.value,
    @required Function(String) onChange,
    @required Function() onCancel,
    @required Function() onRemove,
    @required String path,
    @required int date,
    Key key,
  }) : super(
          onChange: onChange,
          onCancel: onCancel,
          onRemove: onRemove,
          path: path,
          date: date,
          key: key,
        );

  @override
  _InputCameraState createState() => _InputCameraState();
}

class _InputCameraState extends State<InputCamera> {
  CameraCaptureController _controller;

  @override
  void initState() {
    _controller = CameraCaptureController(
      value: widget.value != null ? widget.value.split(',') : [],
    )..addListener(() {
        widget.onChange(_controller.value.join(','));
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: widget.preview$(
        context: context,
        child: _input$(context),
      ),
    );
  }

  Widget _input$(BuildContext context) {
    return ImageChooser(
      controller: _controller,
      path: widget.path,
      onTap: (BuildContext tapContext, String file) {},
    );
  }
}
