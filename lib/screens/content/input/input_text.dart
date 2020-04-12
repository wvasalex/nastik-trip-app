import 'package:flutter/material.dart';
import 'package:journey/shared/shared.dart';
import 'input_base.dart';

class InputText extends InputBase {
  final String value;

  InputText({
    this.value = '',
    @required Function(String) onChange,
    @required Function onCancel,
    @required Function onRemove,
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
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: widget.preview$(
        context: context,
        child: _input$(context),
      ),
    );
  }

  Widget _input$(BuildContext context) {
    return TextInput(
      placeholder: '__',
      value: widget.value,
      onChange: widget.onChange,
      background: Colors.white,
      padding: EdgeInsets.all(0),
      minLines: 1,
      maxLines: 5,
    );
  }
}
